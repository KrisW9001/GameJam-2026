extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $hitbox
@onready var collision_shape_2d: CollisionShape2D = $hitbox/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var ray_up: RayCast2D = $ray_up
@onready var ray_down: RayCast2D = $ray_down
@onready var ray_left: RayCast2D = $ray_left
@onready var ray_right: RayCast2D = $ray_right

@export var damage: int
var dealtdamage: bool = false
var cast: bool = false

func _ready() -> void:
	sprite_2d.visible = false
	dealtdamage = true

func _physics_process(delta: float) -> void:
	if cast == true:
		global_position.x = move_toward(global_position.x, GlobalVariables.player_position.x, 250 * delta)
		global_position.y = move_toward(global_position.y, GlobalVariables.player_position.y, 250 * delta)
		anim_player.play("chase")
	
	if ray_up.is_colliding() and cast:
		destroy()
	elif ray_down.is_colliding() and cast:
		destroy()
	elif ray_left.is_colliding() and cast:
		destroy()
	elif ray_right.is_colliding() and cast:
		destroy()

#return spell to get_parent()
func recall() -> void:
	particles.emitting = true
	dealtdamage = false
	cast = false
	sprite_2d.visible = true
	position = Vector2(0, -20)
	hitbox.set_collision_mask_value(2, true)
	set_collision_layer_value(1, true)

#begin chasing the player
func chase() -> void:
	cast = true
	##timer.start(2)
	await get_tree().create_timer(2).timeout
	destroy()

func invis() -> void:
	anim_player.play("RESET")
	sprite_2d.visible = false
	hitbox.set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)

#make projectile insprite_2d.visible and unable to hurt the player
func destroy() -> void:
	particles.emitting = true
	sprite_2d.visible = false
	hitbox.set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)
	cast = false
	dealtdamage = true
	anim_player.play("RESET")

#deal damage to player
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		destroy()
		body.hurt_player(damage, position.x, position.y)
	if body.is_in_group("wall"):
		destroy()

func _on_timer_timeout() -> void:
	destroy()
