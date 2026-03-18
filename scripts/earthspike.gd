extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_playing: bool = false
#this scene exists to create a blockade to prevent the player from backtracking in the second boss fight
func _ready() -> void:
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true

func activate() -> void:
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	collision_shape_2d.disabled = false
	if !is_playing:
		audio_stream_player.play()
		is_playing = true

func deactivate() -> void:
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
