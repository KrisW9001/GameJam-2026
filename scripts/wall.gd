extends Node2D
class_name wall
@onready var area_2d: Area2D = $Area2D
enum wall_type {north, south, east, west}
@export var type : wall_type
var wall_side: float = 0

func _on_wall_area_body_entered(body) -> void:
	if body.is_in_group("Objects"):
		wall_side = type
		body.velocity = Vector2.ZERO
		print("object has collided with wall")
