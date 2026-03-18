extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer
@export var damage: int
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D
#dark-based projectile used in mage boss fight
const SPEED = 1700
var active: bool = false
var dealtdamage: bool
var flying: bool = false
var aiming: bool = false
var spawn_sfx = load("res://audio/sfx/Magic Dark.wav")
var shoot_sfx = load("res://audio/sfx/Sword 1.wav")

func _ready() -> void:
	active = false
	flying = false
	dealtdamage = true
	animation_player.play("invis")

#if aiming is true, follow the player's movements
func _process(delta: float) -> void:
	if aiming and active:
		position.x = GlobalVariables.player_position.x + 500
		position.y = GlobalVariables.player_position.y
	if flying and active:
		position.x = move_toward(position.x, position.x - 1000, SPEED * delta)

func activate() -> void:
	active = true
	sprite_2d.visible = true
	spawn()

func deactivate() -> void:
	active = false
	sprite_2d.visible = false
	timer.stop()
	particles.emitting = false

func spawn() -> void:
	animation_player.play("spawn")
	aiming = true
	anim_sprite.play("default")
	dealtdamage = false
	audio_player.stream = spawn_sfx
	audio_player.play()
	timer.start(1.5)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		body.hurt_player(damage, position.x, position.y)
		dealtdamage = true

#when timer while spawning, projectile starts flying. if it happens while flying, respawn the projectile
func _on_timer_timeout() -> void:
	if aiming and active:
		aiming = false
		flying = true
		particles.emitting = true
		audio_player.stream = shoot_sfx
		audio_player.play()
		timer.start(1.5)
	elif flying and active:
		flying = false
		particles.emitting = false
		spawn()
