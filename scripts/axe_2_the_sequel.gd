extends CharacterBody2D

const SPEED = 400.0
@onready var area_2d: Area2D = $Area2D
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var anim_player: AnimationPlayer = $AnimPlayer
@onready var particles: CPUParticles2D = $CPUParticles2D

var thrown: bool = false
var target: Vector2
var dealtdamage: bool = false

func _ready() -> void:
	normal_color()
	anim_player.play("RESET")

#move axe to target location when thrown
func _process(delta: float) -> void:
	if thrown == true:
		global_position.x = move_toward(global_position.x, target.x, SPEED * delta)
		global_position.y = move_toward(global_position.y, target.y, (SPEED * .80) * delta)
	if position == target and thrown == true:
		dissapear()

func spawn() -> void:
	particles.emitting = false
	anim_sprite.visible = true
	dealtdamage = false
	thrown = false
	global_position.x = get_parent().position.x
	global_position.y = get_parent().position.y - 40
	normal_color()
	anim_player.play("RESET")

func throw() -> void:
	target = GlobalVariables.player_position
	thrown = true
	anim_player.play("spin")

func dissapear() -> void:
	normal_color()
	anim_player.play("RESET")
	anim_sprite.visible = false
	particles.emitting = true

#declaring animations(or just the color of the axe lol
func normal_color() -> void:
	anim_sprite.play("default")

func red_color() -> void:
	anim_sprite.play("red")

#damage the player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		body.hurt_player(1, position.x, position.y)
		dealtdamage = true
		dissapear()
