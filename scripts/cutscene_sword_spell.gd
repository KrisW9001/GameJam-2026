extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var kill_boss: bool = false
var active: bool = false
var coord_x: float
var coord_y: float
var speed: int = 1000
var spawn_sfx = load("res://audio/sfx/Magic Dark.wav")
var spin_sfx = load("res://audio/sfx/EnergyGun_Charge2.wav")
var shoot_sfx = load("res://audio/sfx/Sword 1.wav")
var catch_sfx = load("res://audio/sfx/Gunshot.wav")

#cutscene prop for the mage end-of-gauntlet cutscene
func _ready() -> void:
	anim_sprite.visible = false
	animation_player.play("RESET")

func activate() -> void:
	anim_sprite.visible = true
	anim_sprite.play("default")
	audio_player.stream = spawn_sfx
	audio_player.play()

#animate position of the sword
func _process(delta: float) -> void:
	if active:
		position.x = move_toward(position.x, coord_x, speed * delta)
		position.y = move_toward(position.y, coord_y, speed * delta)
	if position.x == coord_x and position.y == coord_y:
		active = false

func stop_moving() -> void:
	active = false

func shoot(pos_x: float, pos_y: float) -> void:
	anim_sprite.play("idle")
	coord_x = pos_x
	coord_y = pos_y
	active = true
	audio_player.stream = shoot_sfx
	audio_player.play()

func spin(pos_x: float, pos_y: float) -> void:
	anim_sprite.play("idle")
	coord_x = pos_x
	coord_y = pos_y
	active = true
	audio_player.stream = spin_sfx
	audio_player.play()
	animation_player.play("spin")

func hit_mage() -> void:
	animation_player.play("fade_away")
	speed = 50

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"spin":
			animation_player.play("catch")
			audio_player.stream = catch_sfx
			audio_player.play()
			audio_player.stop()
			active = false
			TalkScenes.mage_talk.dialogue_resource = load("res://dialogue/mage_battle_end_3.dialogue")
			TalkScenes.mage_talk.start()
		"fade_away":
			queue_free()
