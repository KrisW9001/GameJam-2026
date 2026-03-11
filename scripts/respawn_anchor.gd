extends Area2D

@export var location: Vector2

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		GlobalVariables.cur_respawn = location
