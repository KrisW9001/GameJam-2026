extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	anim_sprite.play("none")

func strike() -> void:
	anim_sprite.play("strike")
	audio_stream_player.play()
