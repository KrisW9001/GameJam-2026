extends Area2D

@export var whichroom: String = str(SceneTree)
#When the player enters this, the scene will transition to a different room.

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		CutsceneManager.new_room(whichroom)
