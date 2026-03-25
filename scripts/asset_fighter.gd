extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $hurtbox
@onready var detector: Area2D = $detector
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var resettimer: Timer = $resettimer
@onready var waittimer: Timer = $waittimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var damageplayer: AnimationPlayer = $damageplayer
@onready var offscreen: Sprite2D = $"../Boss Positioning/Offscreen"
@onready var center: Sprite2D = $"../Boss Positioning/Start"
@onready var melee: CollisionShape2D = $detector/melee_range

#declaring sfx
var dmg_sfx = load("res://audio/sfx/Door Close Big.wav")
var die_sfx = load("res://audio/sfx/Explosion.wav")
var throw_sfx = load("res://audio/sfx/Laser Shot.wav")
var charge_sfx = load("res://audio/sfx/Transport Up.wav")
var shing_sfx = load("res://audio/sfx/Metal High.wav")

#declaring stats and variables
var speed: int = 500
var health: int = 10
var dead: bool = false
var in_fight: bool = false
var action: int
var charging: bool = false
var attacking: bool = false
var punch_atk: bool = false
var punch_target: Vector2
var throw_pos: String
var dealtdamage: bool = false

#basic functions to animate the sprite
func jump_in() -> void:
	GlobalVariables.fighter_coords = Vector2(623, 370)
	GlobalVariables.fighter_goto = true
	anim_player.play("enter")
	anim_sprite.play("jump_in")
	print("jumping in")

func _process(delta: float) -> void:
	if GlobalVariables.fighter_goto == true:
		if punch_atk == false:
			position.x = move_toward(position.x, GlobalVariables.fighter_coords.x, speed * delta)
			position.y = move_toward(position.y, GlobalVariables.fighter_coords.y, (speed * .8) * delta)
		elif punch_atk == true:
			position.x = move_toward(position.x, punch_target.x, speed * delta)
			position.y = move_toward(position.y, punch_target.y, speed * delta)
	
	if position == GlobalVariables.fighter_coords and GlobalVariables.cutscenemode:
		idle_l()

func start_fight() -> void:
	in_fight = true
	action = randi_range(0, 5)
	choose_action()

func choose_action() -> void:
	attacking = false
	melee.disabled = true
	dealtdamage = false
	get_tree().call_group("enemy_projectiles", "dissapear")
	if in_fight:
		match action:
			0:
				#top left axe attack
				top_left_axe()
			1:
				#bottom left axe attack
				bottom_left_axe()
			2:
				#punch to the left
				left_punch()
			3:
				#punch to the right
				right_punch()
			4:
				#top right axe attack
				top_right_axe()
			5:
				#bottom right axe attack
				bottom_right_axe()

func top_left_axe() -> void:
	backstep_r()
	GlobalVariables.fighter_coords = Vector2(335, 241)
	await get_tree().create_timer(1).timeout
	charging = true
	charge_r()
	get_tree().call_group("enemy_projectiles", "spawn")
	audio_player.stream = charge_sfx
	audio_player.play()
	throw_pos = "left"
	action = randi_range(3, 5)
	waittimer.start(2)

func bottom_left_axe() -> void:
	backstep_r()
	GlobalVariables.fighter_coords = Vector2(335, 431)
	await get_tree().create_timer(1).timeout
	charging = true
	charge_r()
	get_tree().call_group("enemy_projectiles", "spawn")
	audio_player.stream = charge_sfx
	audio_player.play()
	throw_pos = "left"
	action = randi_range(3, 5)
	waittimer.start(2)

func right_punch() -> void:
	punch_target = GlobalVariables.player_position
	ready_melee_r()
	await get_tree().create_timer(.5).timeout
	punch_atk = true
	attacking = true
	punch_r()
	action = randi_range(4, 5)
	resettimer.start(1)

func left_punch() -> void:
	punch_target = GlobalVariables.player_position
	ready_melee_l()
	await get_tree().create_timer(.5).timeout
	punch_atk = true
	attacking = true
	punch_l()
	action = randi_range(0, 1)
	resettimer.start(1)

func top_right_axe() -> void:
	backstep_l()
	GlobalVariables.fighter_coords = Vector2(816, 241)
	await get_tree().create_timer(1).timeout
	charging = true
	charge_l()
	get_tree().call_group("enemy_projectiles", "spawn")
	audio_player.stream = charge_sfx
	audio_player.play()
	throw_pos = "right"
	action = randi_range(0, 2)
	waittimer.start(2)

func bottom_right_axe() -> void:
	backstep_l()
	GlobalVariables.fighter_coords = Vector2(816, 431)
	await get_tree().create_timer(1).timeout
	charging = true
	charge_l()
	get_tree().call_group("enemy_projectiles", "spawn")
	audio_player.stream = charge_sfx
	audio_player.play()
	throw_pos = "right"
	action = randi_range(0, 2)
	waittimer.start(2)

func end_fight() -> void:
	in_fight = false
	charging = false
	attacking = false

func respawn() -> void:
	in_fight = false
	charging = false
	attacking = false
	get_tree().call_group("enemy_projectiles", "dissapear")
	GlobalVariables.fighter_goto = false
	position = Vector2(-62, 370)

#damage the boss
func hurt_boss(damage: int) -> void:
	health = health - damage
	if health > 0:
		damageplayer.play("damage")
		audio_player.stream = dmg_sfx
		audio_player.play()
	if health < 1:
		end_fight()
		audio_player.stream = die_sfx
		audio_player.play()
		anim_sprite.speed_scale = 0.1
		set_collision_mask_value(2, false)
		hurtbox.set_collision_mask_value(2, false)
		detector.set_collision_mask_value(2, false)
		die_anim()
		damageplayer.play("fade_away")
		CutsceneManager.boss_kill()

func _on_damageplayer_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_away":
		CutsceneManager.cutscene3()
		queue_free()

#when waittimer finishes, throw the axe
func _on_waittimer_timeout() -> void:
	if charging == true:
		match throw_pos:
			"left":
				throw_r()
				get_tree().call_group("enemy_projectiles", "throw")
				charging = false
				attacking = true
				resettimer.start()
			"right":
				throw_l()
				get_tree().call_group("enemy_projectiles", "throw")
				charging = false
				attacking = true
				resettimer.start()

func _on_resettimer_timeout() -> void:
	if attacking == true:
		punch_atk = false
		attacking = false
		choose_action()

#take damage from projectiles
func _on_hurtbox_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Objects") and body.get_child(2).flying:
		hurt_boss(1)

#declaring animations
func idle_l() -> void:
	if !dead:
		anim_sprite.play("idle_l")

func idle_r() -> void:
	if !dead:
		anim_sprite.play("idle_r")

func backstep_l() -> void:
	#this is a backstep moving right and facing left
	if !dead:
		anim_sprite.play("backstep_l")

func backstep_r() -> void:
	#this is a backstep moving left and facing right
	if !dead:
		anim_sprite.play("backstep_r")

func charge_l() -> void:
	if !dead:
		anim_player.play("charge")
		anim_sprite.play("charge_l")

func charge_r() -> void:
	if !dead:
		anim_player.play("charge")
		anim_sprite.play("charge_r")

func throw_l() -> void:
	if !dead:
		anim_player.play("RESET")
		anim_sprite.play("toss_forward_l")
		audio_player.stream = throw_sfx
		audio_player.play()

func throw_r() -> void:
	if !dead:
		anim_player.play("RESET")
		anim_sprite.play("toss_forward_r")
		audio_player.stream = throw_sfx
		audio_player.play()

func punch_l() -> void:
	if !dead:
		anim_sprite.play("melee_l")
		melee.disabled = false

func punch_r() -> void:
	if !dead:
		anim_sprite.play("melee_r")
		melee.disabled = false

func ready_melee_l() -> void:
	if !dead:
		anim_sprite.play("ready_melee_l")
		audio_player.stream = shing_sfx
		audio_player.play()

func ready_melee_r() -> void:
	if !dead:
		anim_sprite.play("ready_melee_r")
		audio_player.stream = shing_sfx
		audio_player.play()

func die_anim() -> void:
	anim_sprite.play("die")
	dead = true

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		body.hurt_player(1, position.x, position.y)
		dealtdamage = true
