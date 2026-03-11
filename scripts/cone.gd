extends CharacterBody2D

@onready var ray_up: RayCast2D = $ray_up
@onready var ray_down: RayCast2D = $ray_down
@onready var ray_left: RayCast2D = $ray_left
@onready var ray_right: RayCast2D = $ray_right

#defining stats
@export_enum("explode", "stop", "break_apart", "pierce") var coll_type: String
enum size_category {small, medium, large}

#object stats, can be changed inthe inspector tab
@export var category: size_category
@export var throw_damage: int
@export var coll_side: int
@export var spawn_coords: Vector2

#check if any of the raycasts have collided with something, and activate their collision effect if they have
func _physics_process(delta: float) -> void:
	if ray_up.is_colliding():
		coll_side = 0
		get_child(2).collide()
	elif ray_down.is_colliding():
		coll_side = 1
		get_child(2).collide()
	elif ray_left.is_colliding():
		coll_side = 2
		get_child(2).collide()
	elif ray_right.is_colliding():
		coll_side = 3
		get_child(2).collide()

func respawn() -> void:
	position = spawn_coords
