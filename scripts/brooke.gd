extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D
@export var whichtalk: DialogueResource


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
		TalkScenes.brooke_talk.dialogue_resource = whichtalk
		body.inspect_prompt.visible = true
		body.can_talk_b = true
		print("showing inspect prompt")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_b = false
