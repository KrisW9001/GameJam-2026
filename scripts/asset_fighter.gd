extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $hurtbox
@onready var detector: Area2D = $detector
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var damagetimer: Timer = $damagetimer
@onready var waittimer: Timer = $waittimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var damageplayer: AnimationPlayer = $damageplayer
@onready var bow_1: Sprite2D = $"../Boss Positioning/Bow_1"
@onready var bow_2: Sprite2D = $"../Boss Positioning/Bow_2"
@onready var bow_3: Sprite2D = $"../Boss Positioning/Bow_3"
@onready var bow_4: Sprite2D = $"../Boss Positioning/Bow_4"
@onready var bow_5: Sprite2D = $"../Boss Positioning/Bow_5"
@onready var bow_6: Sprite2D = $"../Boss Positioning/Bow_6"
@onready var axe_1: Sprite2D = $"../Boss Positioning/Axe_1"
@onready var axe_2: Sprite2D = $"../Boss Positioning/Axe_2"
@onready var axe_3: Sprite2D = $"../Boss Positioning/Axe_3"
@onready var axe_4: Sprite2D = $"../Boss Positioning/Axe_4"
@onready var dagger_1: Sprite2D = $"../Boss Positioning/Dagger_1"
@onready var dagger_2: Sprite2D = $"../Boss Positioning/Dagger_2"
@onready var offscreen: Sprite2D = $"../Boss Positioning/Offscreen"
@onready var center: Sprite2D = $"../Boss Positioning/Start"

#declaring sfx
var dmg_sfx = preload("res://audio/sfx/Door Close Big.wav")
var die_sfx = preload("res://audio/sfx/Explosion.wav")
var throw_sfx = preload("res://audio/sfx/Laser Shot.wav")
var charge_sfx = load("res://audio/sfx/Transport Up.wav")

#declaring stats and variables
var speed: int = 500
var health: int = 10
var throw_strength: int = -1100
var dead: bool = false
var attacking: bool = false
var held_object: Node2D = null
var action: int
var choosespot: int
var target: Vector2

var pos_nodes: Dictionary
#var axe: Node = get_parent().axe
#variables to control fighter's state
@export_enum("wait", "bow_atk", "axe_throw", "axe_toss", "move", "cutscene", "die") var state: String

func _ready() -> void:#defining node paths
	pos_nodes = {
		1: bow_1,
		2: bow_2,
		3: bow_3,
		4: bow_4,
		5: bow_5,
		6: bow_6,
		7: axe_1,
		8: axe_2,
		9: axe_3,
		10: axe_4,
		11: dagger_1,
		12: dagger_2,
		13: offscreen,
		14: center
	}
	state = "cutscene"
	idle_r_anim()

func _process(delta: float) -> void:
	if GlobalVariables.fighter_goto:
		position.x = move_toward(position.x, GlobalVariables.fighter_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.fighter_coords.y, (speed / 2) * delta)
		pass
	
	#exectute code when fighter reaches their target location
	if position == GlobalVariables.fighter_coords:
		if GlobalVariables.cutscenemode:
			stop_jump_in()
		else:
			print("arrived")
			#for a in 6:
			if action > 2 and action < 5:
				if !attacking:
					axe_throw()
	
	#flip sprite to face player
	if !state == "cutscene" and !state == "move" and !state == "bow_atk":
		if GlobalVariables.player_position < position:
			anim_sprite.flip_h = true
		else:
			anim_sprite.flip_h = false
	
	#match state:
		#"wait":
			#attacking = false
			#waittimer.start()
		#"die":
			#pass

func choose_action() -> void:
	if !attacking:
		action = randi_range(1, 6)
		match action:
			1:
				print("performing action 1")
				choose_action()
			2:
				print("performing action 2")
				choose_action()
			3:
				print("performing action 3")
				choosespot = randi_range(1, 2)
				match choosespot:
					#1: top left axe throw,  2: bottom left axe throw
					1:
						var coord = pos_nodes.get(10).position
						anim_sprite.play("backstep_r")
						state = "axe_throw"
						move(coord)
					2:
						var coord = pos_nodes.get(9).position
						anim_sprite.play("backstep_r")
						state = "axe_throw"
						move(coord)
			4:
				print("performing action 4")
				choosespot = randi_range(1, 2)
				match choosespot:
					#1: top left axe throw,  2: bottom left axe throw
					1:
						var coord = pos_nodes.get(7).position
						anim_sprite.play("backstep_r")
						state = "axe_throw"
						move(coord)
					2:
						var coord = pos_nodes.get(8).position
						anim_sprite.play("backstep_r")
						state = "axe_throw"
						move(coord)
			5:
				print("performing action 5")
				choose_action()
			6:
				print("performing action 6")
				choose_action()

#basic functions to animate the sprite
func jump_in() -> void:
	GlobalVariables.fighter_coords = center.position
	GlobalVariables.fighter_goto = true
	anim_player.play("enter")
	anim_sprite.play("jump_in")
	print("jumping in")

func stop_jump_in() -> void:
	state = "wait"
	idle_r_anim()
	GlobalVariables.fighter_goto = false

#move to the location of the chosen attack
func move(coord: Vector2) -> void:
	GlobalVariables.fighter_coords = coord
	GlobalVariables.fighter_goto = true

##exectute a horizontal axe-throwing attack
func axe_throw() -> void:
	attacking = true
	get_parent().axe.set_collision_mask_value(2, true)
	held_object = get_parent().axe
	get_parent().axe.get_node("ObjectLogic").pickup(self)
	anim_player.play("charge")

func idle_r_anim() -> void:
	if !dead:
		anim_sprite.play("idle_r")

func die_anim() -> void:
	anim_sprite.play("die")
	dead = true

#damage the boss
func hurt_boss(damage: int) -> void:
	health = health - damage
	if health > 0:
		damageplayer.play("damage")
		audio_player.stream = dmg_sfx
		audio_player.play()
	if health < 1:
		audio_player.stream = die_sfx
		audio_player.play()
		anim_sprite.speed_scale = 0.1
		set_collision_mask_value(2, false)
		hurtbox.set_collision_mask_value(2, false)
		detector.set_collision_mask_value(2, false)
		die_anim()
		damageplayer.play("fade_away")
		CutsceneManager.boss_kill()
		state = "die"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"charge":
			target = GlobalVariables.player_position
			get_parent().axe.get_node("ObjectLogic").fighter_throw(target)
			held_object = null
			attacking = false
			anim_sprite.play("toss_forward")
			anim_player.stop()
			waittimer.start()

func _on_damageplayer_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_away":
			print("Playing cutscene")
			Engine.set("time_scale", 1)
			CutsceneManager.cutscene3()
			queue_free()

#when waittimer finishes, randomly pick a new attack to begin
func _on_waittimer_timeout() -> void:
	print("choosing action")
	choose_action()

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim_sprite.animation:
		#finish throwing attack
		"toss_forward":
			print("finishing throw attack")
			anim_player.play("RESET")
			anim_sprite.play("idle_r")
			idle_r_anim()

#take damage from projectiles
func _on_hurtbox_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Objects") and body.get_child(3).flying:
		hurt_boss(1)
