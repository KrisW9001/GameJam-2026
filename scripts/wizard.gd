extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var hurtbox: Area2D = $hurtbox
@onready var detector: Area2D = $detector
@onready var hurtshape: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var detectshape: CollisionShape2D = $detector/CollisionShape2D
@onready var shader: ColorRect = $ColorRect
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var ice_spell: CharacterBody2D = $IceSpell

#declaring variables
var die_sfx = load("res://audio/sfx/Door Close Big.wav")
var charge_sfx = load("res://audio/sfx/Transport Up.wav")
var shoot_sfx = load("res://audio/sfx/Laser Shot.wav")
@export_enum("idle", "attack", "wait", "die") var state: String
#wiz num is used to determine which projectile belongs to which wizard
@export var spawn_coords: Vector2
var attacking: bool = false
var inrange: bool = false
#this wizard enemy will remain stationary at all times and throw projectiles at the player if they enter their detector range

func _ready() -> void:
	state = "idle"
	shader.visible = false

func _process(delta: float) -> void:
	if !inrange:
		state = "idle"
		attacking = false
	elif inrange and !attacking:
		state = "attack"
		charge()
	match state:
		"idle":
			anim_sprite.play("idle")
			anim_player.play("RESET")
			#ice_spell.destroy
			ice_spell.anim_player.play("RESET")
			timer.stop()
			ice_spell.timer.stop()
		"attack":
			anim_sprite.play("charge")
			#if !attacking and inrange:
				#charge()
		"die":
			get_tree().call_group("Player", "pause_shaders")
			anim_sprite.play("idle")
			anim_player.play("RESET")
			shader.visible = true
			hurtshape.disabled = true
			detectshape.disabled = true
			await get_tree().create_timer(0.5).timeout
			visible = false
			shader.visible = false
			position = Vector2(5000,5000)

#upon taking damage from the player, kill the wizard. keep in mind wizards will often be out of reach from the player.
func hurt_enemy(player_damage: float):
	audio_player.stop()
	audio_player.stream = die_sfx
	audio_player.play()
	state = "die"
	timer.stop()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Objects") and body.get_child(2).flying:
		audio_player.stop()
		audio_player.stream = die_sfx
		audio_player.play()
		state = "die"
		timer.stop()

#begin attack cycle when player is in range
func _on_detector_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and body.dead == false:
		inrange = true

#stop attacking if the player exits their range
func _on_detector_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and body.dead == false:
		inrange = false
		if !ice_spell.cast:
			ice_spell.invis()

#charge for two seconds
func charge() -> void:
	timer.start(2)
	ice_spell.recall()
	attacking = true
	anim_player.play("charge")
	ice_spell.anim_player.play("charge")
	audio_player.stream = charge_sfx
	audio_player.play()

#depending on the current state, do different actions when the timer is done
func _on_timer_timeout() -> void:
	match state:
		"attack":
			anim_player.play("RESET")
			anim_sprite.play("shoot")
			audio_player.stream = shoot_sfx
			audio_player.play()
			state = "wait"
			ice_spell.chase()
			timer.start(2)
		"wait":
			attacking = false
			state = "attack"
			ice_spell.destroy()
		"die":
			ice_spell.destroy()

func respawn() -> void:
	state = "idle"
	hurtshape.disabled = false
	detectshape.disabled = false
	visible = true
	shader.visible = false
	position = spawn_coords
