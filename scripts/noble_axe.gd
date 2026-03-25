extends CharacterBody2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@export var damage: int
var moving: bool = false
var dealtdamage: bool = false

func _ready() -> void:
	anim_player.play("disable")

func _process(delta: float) -> void:
	if moving == true:
		position.x = move_toward(position.x, position.x + 1000, 500 * delta)

func spawn() -> void:
	timer.stop()
	anim_player.play("enable")
	position = Vector2(-490, -2396)
	timer.start(1)
	audio_player.play()

func disable() -> void:
	anim_player.play("disable")
	moving = false
	position = Vector2(-3000, -3000)
	dealtdamage = false

#after timer ends, start moving to the right
func _on_timer_timeout() -> void:
	anim_player.play("throw")
	audio_player.stop()
	moving = true
	timer.start(5)

#deal damage to player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		body.hurt_player(damage, position.x, position.y)
		dealtdamage = true
