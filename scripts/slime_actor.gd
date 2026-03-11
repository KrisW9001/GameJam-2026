extends AnimatedSprite2D
@onready var color_rect: ColorRect = $ColorRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var is_playing: bool = false

#basic actor that does a single thing in a cutscene
func _ready() -> void:
	play("move")
	flip_h = true

func die() -> void:
	play("die")
	color_rect.visible = true
	if !is_playing:
		audio_stream_player.play()
		is_playing = true

func _on_animation_finished() -> void:
	queue_free()
