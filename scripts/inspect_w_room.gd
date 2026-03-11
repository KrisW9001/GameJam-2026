extends Area2D

@export var whichdialogue: DialogueResource
@export var whichroom: String = str(SceneTree)

#code for triggering inspect dialogue
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		TalkScenes.protag_talk.dialogue_resource = whichdialogue
		body.inspect_prompt.visible = true
		body.can_inspect = true
		print("showing inspect prompt")

func _on_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_inspect = false

func new_room() -> void:
	CutsceneManager.new_room(whichroom)
