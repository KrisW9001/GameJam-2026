extends Area2D

@export var lock_coord = Vector2()
#var disabled: bool = get_child(0).disabled()

func _ready() -> void:
	GlobalVariables.cameralock = false

func _on_body_entered(_body: CharacterBody2D) -> void:
	if _body.is_in_group("Player"):
		print("locking camera")
		GlobalVariables.lock_pos.x = lock_coord.x
		GlobalVariables.lock_pos.y = lock_coord.y
		GlobalVariables.cameralock = true

func _on_body_exited(_body: CharacterBody2D) -> void:
	if _body.is_in_group("Player"):
		print("unlocking camera")
		GlobalVariables.cameralock = false
