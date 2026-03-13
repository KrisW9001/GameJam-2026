extends Node
class_name ObjectLogic1

#shoutouts to Mostly Mad Productions

#this is the first of multiple object logic codes, used for small objects
@onready var anim_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var coll_shape: CollisionShape2D = $"../CollisionShape2D"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var enemybox: Area2D = $"../enemybox"
@onready var despawn: Timer = $"../despawn"
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
var start_temp: bool = false
var enemy_proj: bool = false
var target: Vector2
var dealtdamage: bool = false
#creating an enum to make referencing animations easier
#@export_enum("idle", "explode", "bounce", "fly_left", "fly_right", "fly_up", "fly_down", "hold_left", "hold_right", "hold_up", "hold_down") var anim: String = "idle"

func _ready() -> void:
	get_parent().add_to_group("can_pickup")
	anim_sprite.play("default")
	obj_coll_type = get_parent().coll_type
	obj_size = 0
	obj_damage = 0

func _physics_process(delta: float) -> void:
	if held_by:
		#if this were a heavy object, the player would be slowed down and possibly even unable to run. however, this object is supposed to be lighter, so that code isn't here.
		var target_pos: Vector2 = held_by.global_position + Vector2(0, -25)
		get_parent().global_position = lerp(get_parent().global_position, target_pos, position_lerp_weight*delta)
	else:
		get_parent().velocity.x = lerp(get_parent().velocity.x, x_velocity, friction_lerp_weight*delta)
		get_parent().velocity.y = lerp(get_parent().velocity.y, y_velocity, friction_lerp_weight*delta)
		get_parent().move_and_slide()
		
	if get_parent().velocity.length() < 3.0:
		y_velocity = 0.0
		x_velocity = 0.0
	
	#stop the axe if it reaches target as an enemy projectile
	if enemy_proj:
		if get_parent().position == target:
			animation_player.play("ground")
			cooldown()
		else:
			get_parent().position.x = move_toward(get_parent().position.x, target.x, 8)
			get_parent().position.y = move_toward(get_parent().position.y, target.y, 6)
			if get_parent().position < target:
				animation_player.play("spin_r")
			else:
				animation_player.play("spin_l")

func pickup(holder: CharacterBody2D) -> void:
	held_by = holder
	get_parent().visible = true
	animation_player.play("RESET")
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
	if x_velocity > 0:
		animation_player.play("spin_r")
	else:
		animation_player.play("spin_l")
	despawn.stop()
	await get_tree().create_timer(.3).timeout
	y_velocity = 0.0
	x_velocity = 0.0
	animation_player.play("ground")
	flying = false
	cooldown()

#unique code for when the axe is being thrown by the fighter
func fighter_throw(targeting: Vector2) -> void:
	held_by = null
	despawn.stop()
	get_parent().set_collision_layer_value(5, false)
	target = targeting
	enemy_proj = true
	dealtdamage = false

#when an object is dropped by the player or ends its intended purpose after being thrown, enter a grace period where it cannot be picked back up
func cooldown() -> void:
	enemy_proj = false
	get_parent().set_collision_layer_value(5, false)
	if obj_coll_type == "temp_stop":
		if !start_temp:
			temp_stop()
			start_temp = true

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
			"temp_stop":
				if !start_temp:
					temp_stop()
					start_temp = true
				

#controls objects that explode into a hitbox when colliding with something while thrown
func explode() -> void:
	held_by = null
	anim_sprite.play("explode")
	await get_tree().create_timer(0.4).timeout
	get_parent().visible = false

#if the object is a temp_stop type, send a signal to start the despawn timer
func temp_stop() -> void:
	print("starting despawn timer")
	anim_sprite.play("red")
	despawn.start()

func _on_despawn_timeout() -> void:
	if held_by == null:
		if !flying:
			explode()
	else:
		despawn.start(1)

func _on_enemybox_body_entered(body: Node2D) -> void:
	if !dealtdamage and enemy_proj:
		if body.is_in_group("Player") and body.dead == false:
			print("you took damage from an axe")
			dealtdamage = true
			body.hurt_player(get_parent().throw_damage, get_parent().position.x, get_parent().position.y)
