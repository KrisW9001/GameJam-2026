extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var glitch_effect: ColorRect = $glitch_effect
@onready var warp_player: AnimationPlayer = $warp
@onready var damage: AnimationPlayer = $damage
@onready var attack_timer: Timer = $AttackTimer
@onready var hitbox_right: CollisionShape2D = $Area2D/hitbox_right
@onready var hitbox_left: CollisionShape2D = $Area2D/hitbox_left
@onready var hurtbox: Area2D = $hurtbox

const speed: int = 300
var health: int = 20
var in_fight: bool = false
var cur_action: int = 0
var move_right: bool = false
var move_left: bool = false
var punch_loc: Vector2
var dealtdamage: bool = false

var dmg_sfx = load("res://audio/sfx/Door Close Big.wav")
var die_sfx = preload("res://audio/sfx/Explosion.wav")
var warp_sfx = load("res://audio/sfx/Misc_GlitchNoisy1.wav")
var punch_sfx = load("res://audio/sfx/Sword 1.wav")

func _ready() -> void:
	idle_r()

func respawn() -> void:
	in_fight = false
	health = 20
	idle_r()
	position = Vector2(0, -2598)

func _process(delta: float) -> void:
	if GlobalVariables.noble_goto == true:
		position.x = move_toward(position.x, GlobalVariables.noble_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.noble_coords.y, (speed / 2) * delta)
		if position == GlobalVariables.noble_coords and CutsceneManager.incut10 == true:
			idle_l()
	
	if move_right == true:
		position.x = move_toward(position.x, punch_loc.x + 200, 500 * delta)
	
	if move_left == true:
		position.x = move_toward(position.x, punch_loc.x - 200, 500 * delta)

#begin the fight after a cutscene
func fight_start() -> void:
	in_fight = true
	GlobalVariables.noble_goto = false
	cur_action = randi_range(0, 4)
	next_action()

#end the fight when the boss reaches 0 hp
func fight_end() -> void:
	in_fight = false
	get_tree().call_group("enemy_projectiles", "deactivate")
	get_tree().call_group("axe", "disable")
	recoil()
	hitbox_left.disabled = true
	hitbox_right.disabled = true
	audio_player.stream = die_sfx
	audio_player.play()
	anim_sprite.modulate = Color(0,0,0)
	CutsceneManager.boss_kill()
	await get_tree().create_timer(3).timeout
	CutsceneManager.cutscene13()

func next_action() -> void:
	get_tree().call_group("enemy_projectiles", "deactivate")
	get_tree().call_group("axe", "disable")
	move_right = false
	move_left = false
	hitbox_left.disabled = true
	hitbox_right.disabled = true
	dealtdamage = false
	if in_fight:
		match cur_action:
			0:
				#giant axe
				giant_axe()
			1:
				#left-side lightning
				left_lightning()
			2:
				#right-side lightning
				right_lightning()
			3:
				#punch from the left of the player
				punch_from_left()
			4:
				#punch from the right of the player
				punch_from_right()

#scripting attacks
func left_lightning() -> void:
	GlobalVariables.noble_coords = Vector2(-500, -2450)
	warp()
	idle_r()
	await get_tree().create_timer(.5).timeout
	shoot_r()
	get_tree().call_group("enemy_projectiles", "activate")
	cur_action = randi_range(3,4)
	attack_timer.start(3)

func right_lightning() -> void:
	GlobalVariables.noble_coords = Vector2(500, -2450)
	warp()
	idle_l()
	await get_tree().create_timer(.5).timeout
	shoot_l()
	get_tree().call_group("enemy_projectiles", "activate")
	cur_action = randi_range(3,4)
	attack_timer.start(3)

func giant_axe() -> void:
	GlobalVariables.noble_coords = Vector2(0, -2598)
	warp()
	jump_l()
	get_tree().call_group("axe", "spawn")
	cur_action = randi_range(1,4)
	attack_timer.start(3)

func punch_from_left() -> void:
	GlobalVariables.noble_coords = Vector2(GlobalVariables.player_position.x - 100, GlobalVariables.player_position.y)
	warp()
	idle_r()
	await get_tree().create_timer(.9).timeout
	punch_r()
	hitbox_right.disabled = false
	audio_player.stream = punch_sfx
	audio_player.play()
	#set punch_loc to be used to move noble during punch attack
	punch_loc = global_position
	move_right = true
	cur_action = randi_range(0,2)
	attack_timer.start(1)

func punch_from_right() -> void:
	GlobalVariables.noble_coords = Vector2(GlobalVariables.player_position.x + 100, GlobalVariables.player_position.y)
	warp()
	idle_l()
	await get_tree().create_timer(.9).timeout
	punch_l()
	hitbox_right.disabled = false
	audio_player.stream = punch_sfx
	audio_player.play()
	#set punch_loc to be used to move noble during punch attack
	punch_loc = global_position
	move_left = true
	cur_action = randi_range(0,2)
	attack_timer.start(1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		body.hurt_player(1, position.x, position.y)
		dealtdamage = true

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Objects") and body.get_child(2).flying:
		hurt_boss(1)

#taking damage
func hurt_boss(damage: int) -> void:
	health = health - damage
	if health > 0:
		cutscene_damage()
	if health < 1:
		print("boss is dead")
		attack_timer.stop()
		fight_end()
		set_collision_mask_value(2, false)

func _on_attack_timer_timeout() -> void:
	next_action()

#declaring animations
func idle_l() -> void:
	anim_sprite.play("idle_l")

func idle_r() -> void:
	anim_sprite.play("idle_r")

func walk_l() -> void:
	anim_sprite.play("walk_l")

func walk_r() -> void:
	anim_sprite.play("walk_r")

func shoot_l() -> void:
	anim_sprite.play("shoot_l")

func shoot_r() -> void:
	anim_sprite.play("shoot_r")

func point_l() -> void:
	anim_sprite.play("point_l")

func point_r() -> void:
	anim_sprite.play("point_r")

func jump_l() -> void:
	anim_sprite.play("jump_l")

func jump_r() -> void:
	anim_sprite.play("jump_r")

func weak_l() -> void:
	anim_sprite.modulate = Color(1,1,1)
	anim_sprite.play("weak_l")

func weak_r() -> void:
	anim_sprite.modulate = Color(1,1,1)
	anim_sprite.play("weak_r")

func punch_l() -> void:
	anim_sprite.play("punch_l")

func punch_r() -> void:
	anim_sprite.play("punch_r")

func recoil() -> void:
	anim_sprite.play("fight_end")

func warp() -> void:
	position = GlobalVariables.noble_coords
	audio_player.stream = warp_sfx
	audio_player.play()
	warp_player.play("glitch_warp")
	get_tree().call_group("Player", "pause_shaders")

func cutscene_damage() -> void:
	damage.play("damage_flash")
	audio_player.stream = dmg_sfx
	audio_player.play()
