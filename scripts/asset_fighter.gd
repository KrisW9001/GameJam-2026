extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $hurtbox
@onready var detector: Area2D = $detector
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var damagetimer: Timer = $damagetimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
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

#defining node paths
var pos_nodes: Dictionary = {
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

#determining stats
var speed: int = 150
var health: int = 10
var dead: bool = false
#variables to control fighter's state
@export_enum("wait", "bow_atk", "axe", "knife", "cutscene", "die") var state: String

func _ready() -> void:
	state = "cutscene"
	anim_sprite.play("idle_r")
	#position = offscreen.position

func _process(delta: float) -> void:
	if GlobalVariables.fighter_goto:
		position.x = move_toward(position.x, GlobalVariables.fighter_coords.x, 1000 * delta)
		position.y = move_toward(position.y, GlobalVariables.fighter_coords.y, 1000 * delta)
		pass
	
	if position == GlobalVariables.fighter_coords:
		stop_jump_in()
	
	#if dead and !state == "die":
		#anim_sprite.play("die")
		#state == "die"
	
	match state:
		"die":
			set_collision_mask_value(2, false)
			hurtbox.set_collision_mask_value(2, false)
			detector.set_collision_mask_value(2, false)
			anim_sprite.play("die")
			anim_player.play("fade_away")
			CutsceneManager.boss_kill()

#basic functions to animate the sprite
func jump_in() -> void:
	GlobalVariables.fighter_coords = center.position
	GlobalVariables.fighter_goto = true
	anim_player.play("enter")
	anim_sprite.play("jump_in")
	print("jumping in")

func stop_jump_in() -> void:
	anim_sprite.play("idle_l")
	GlobalVariables.fighter_goto = false

func hurt_boss(damage: int) -> void:
	health = health - damage
	if health > 0:
		anim_player.play("damage")
		audio_player.stream = dmg_sfx
		audio_player.play()
	if health < 1:
		audio_player.stream = die_sfx
		audio_player.play()
		anim_sprite.speed_scale = 0.1
		state = "die"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_away":
		Engine.set("time_scale", 1)
		CutsceneManager.cutscene3()
		queue_free()
