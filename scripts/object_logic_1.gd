extends Node
class_name ObjectLogic

#shoutouts to Mostly Mad Productions

#this is the first of multiple object logic codes, used for small objects
@onready var parent_anim_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var coll_shape: CollisionShape2D = $"../CollisionShape2D"
@export var friction_lerp_weight: float = 16.5
@export var position_lerp_weight: float = 28.5
@export var gravity_x: float = 1000.0
@export var gravity_y: float = 1000.0
@export var bounces: int = 2
@export var flying: bool = false
#axis velocity determines the direction the object travels in when thrown, see throw function
var y_velocity: float = 0.0
var x_velocity: float = 0.0
#axis offset determines which direction the object will travel in when dropped, see drop function
var y_offset: float = 0.0
var x_offset: float = 0.0
var held_by: CharacterBody2D = null
#object stats: values are determined in the object itself and then read by this code
var obj_coll_type: String
var obj_size: float
var obj_damage: float
#creating an enum to make referencing animations easier
#@export_enum("idle", "explode", "bounce", "fly_left", "fly_right", "fly_up", "fly_down", "hold_left", "hold_right", "hold_up", "hold_down") var anim: String = "idle"

func _ready() -> void:
	get_parent().add_to_group("can_pickup")
	obj_coll_type = get_parent().coll_type
	obj_size = 0
	obj_damage = 0

func _physics_process(delta: float) -> void:
	if held_by:
		#if this were a heavy object, the player would be slowed down and possibly even unable to run. however, this object is supposed to be lighter, so that code isn't here.
		var target_pos: Vector2 = held_by.global_position + Vector2(0, -25)
		get_parent().global_position = lerp(get_parent().global_position, target_pos, position_lerp_weight*delta)
		#get_parent().set_collision_layer_value(2, false)
	else:
		#get_parent().set_collision_layer_value(2, true)
		get_parent().velocity.x = lerp(get_parent().velocity.x, x_velocity, friction_lerp_weight*delta)
		get_parent().velocity.y = lerp(get_parent().velocity.y, y_velocity, friction_lerp_weight*delta)
		get_parent().move_and_slide()
		
	if get_parent().velocity.length() < 5.0:
		y_velocity = 0.0
		x_velocity = 0.0

func pickup(holder: CharacterBody2D) -> void:
	held_by = holder
	await get_tree().create_timer(0.18).timeout
	get_parent().velocity = Vector2.ZERO

func drop(global_pos: Vector2, x_drop: float, y_drop: float) -> void:
	x_offset = x_drop
	y_offset = y_drop
	held_by = null
	#animate the object being put down, using values set by the player script
	var pos_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.tween_property(get_parent(), "global_position", global_pos + Vector2(x_offset,y_offset), 0.1)
	get_parent().velocity = Vector2.ZERO

func throw(throw_x: float, throw_y: float) -> void:
	held_by = null
	get_parent().velocity = Vector2(throw_x, throw_y)
	flying = true
	y_velocity = throw_y
	x_velocity = throw_x
	await get_tree().create_timer(.3).timeout
	y_velocity = 0.0
	x_velocity = 0.0
	flying = false
	cooldown()

#when an object is dropped by the player or ends its intended purpose after being thrown, enter a grace period where it cannot be picked back up
func cooldown() -> void:
	coll_shape.disabled = true
	await get_tree().create_timer(1).timeout
	coll_shape.disabled = false

func collide() -> void:
	if y_velocity or x_velocity:
		#if obj_coll_type != "explode":
		match obj_coll_type:
			"explode":
				explode()
			"stop":
				match get_parent().coll_side:
					0:
						print("object hit a wall above it")
					1:
						print("object hit a wall below it")
					2:
						print("object hit a wall to the left of it")
					3:
						print("object hit a wall to the right of it")
				

#controls objects that explode into a hitbox when colliding with something while thrown
func explode() -> void:
	parent_anim_sprite.play("explode")
	await get_tree().create_timer(0.4).timeout
	get_parent().queue_free()
