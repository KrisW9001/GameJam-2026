extends CharacterBody2D

@export var whichdialogue: DialogueResource
@onready var area_2d: Area2D = $Area2D

#code for triggering inspect dialogue
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_inspect = false

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and GlobalVariables.cutscenemode == false:
		TalkScenes.protag_talk.dialogue_resource = whichdialogue
		body.inspect_prompt.visible = true
		body.can_inspect = true
		print("showing inspect prompt")
