extends Sprite2D

@export var whichdialogue: DialogueResource
@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var can_take: bool = true

func _ready() -> void:
	if !GlobalVariables.haspass:
		visible = true
		can_take = true

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		TalkScenes.protag_talk.dialogue_resource = whichdialogue
		body.inspect_prompt.visible = true
		body.can_inspect = true

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_inspect = false

func appear() -> void:
	visible = true
	can_take = true

func despawn() -> void:
	audio_stream_player.play()

func _on_audio_stream_player_finished() -> void:
	visible = false
	can_take = false
