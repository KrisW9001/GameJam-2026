extends CharacterBody2D

#declaring connected child nodes
@onready var slimebody: AnimatedSprite2D = $slimebody
@onready var metal_gear_meme: AnimatedSprite2D = $"metal gear meme"
@onready var box: Area2D = $box
@onready var hurt: Area2D = $hurt
@onready var detector: Area2D = $detector
@onready var hitbox: CollisionShape2D = $box/CollisionShape2D
@onready var slimezone: CollisionShape2D = $detector/slimezone
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var shader: ColorRect = $ColorRect
@onready var debug_1: Label = $debug1
@onready var audio_player: AudioStreamPlayer = $AudioPlayer
@onready var timer: Timer = $Timer

#variables for sfx
var is_playing: bool = false
var detect_sfx = preload("res://audio/sfx/Metal High.wav")
var die_sfx = preload("res://audio/sfx/Door Close Big.wav")

#general stats
const speed: int = 120
const recoil: int = 75
var cur_speed: int = 0
const max_speed: int = 350
var target = Vector2()
var waittohit: bool = false
var chaseok: bool = false
var dealtdamage: bool = false
var dead: bool = false
var deadcounter: int
@export var damage: int = 1

#variables to control slime's state
@export_enum("idle", "chase", "detect", "giveup", "recoil", "wait", "die") var state: String
@export var spawn_coords: Vector2
var dist_x = (position.x - GlobalVariables.player_position.x)
var dist_y = (position.y - GlobalVariables.player_position.y)

func _ready() -> void:
	state = "idle"
	metal_gear_meme.visible = false
	shader.visible = false
	slimebody.flip_h = false
	chaseok = false
	waittohit = false
	deadcounter = 0
	slimestates()

#control slime's actions based on what state they're currently in
func _physics_process(delta: float) -> void:
	if waittohit:
		hitbox.disabled = true
	elif !waittohit:
		hitbox.disabled = false
	
	if deadcounter == 6:
		dead = true
	else:
		dead = false
	
	#increse speed while chasing the player
	if chaseok and state == "chase":
		if cur_speed < max_speed:
			cur_speed += 20
	
	if position == target and !state == "wait":
		cur_speed = 0
		state = "wait"
		slimestates()
	
	#execute behavior depending on current state
	match state:
		"idle":
			cur_speed = 0
		"chase":
			if chaseok and !dealtdamage:
				position.x = move_toward(position.x, target.x,cur_speed * delta)
				position.y = move_toward(position.y, target.y,cur_speed * delta)
				if position.x < GlobalVariables.player_position.x:
					slimebody.flip_h = false
				elif position.x > GlobalVariables.player_position.x:
					slimebody.flip_h = true
		"detect":
			if position.x < GlobalVariables.player_position.x:
				slimebody.flip_h = false
			elif position.x > GlobalVariables.player_position.x:
				slimebody.flip_h = true
		"recoil":
			position.x = move_toward(position.x, GlobalVariables.player_position.x,recoil * (delta * -1))
			position.y = move_toward(position.y, GlobalVariables.player_position.y,recoil * (delta * -1))
	move_and_slide()

#handles the switching of states and use of the timer.
func slimestates() -> void:
	match state:
		"idle":
			slimebody.play("idle")
			chaseok = false
			waittohit = false
		"chase":
			slimebody.play("detect")
		"detect":
			timer.wait_time = 0.5
			timer.start()
		"giveup":
			slimebody.play("giveup")
			timer.wait_time = 0.3
			timer.start()
		"recoil":
			slimebody.play("move")
			waittohit = true
			timer.wait_time = 0.6
			timer.start()
		"wait":
			timer.wait_time = 0.5
			timer.start()
		"die":
			timer.stop()
			particles.emitting = true
			hitbox.disabled = true
			box.set_collision_mask_value(2, false)
			slimezone.disabled = true
			shader.visible = true
			chaseok = false
			slimebody.play("die")
			get_tree().call_group("Player", "pause_shaders")
			timer.wait_time = 0.3
			timer.start()

#if player enters the slime zone, put slime in detect state
func _on_detector_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and body.dead == false:
		slimebody.play("detect")
		metal_gear_meme.visible = true
		audio_player.stream = detect_sfx
		audio_player.play()
		state = "detect"
		chaseok = true
		slimestates()

#if player exits slimezone, put slime in giveup state
func _on_detector_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		timer.stop()
		state = "giveup"
		chaseok = false
		waittohit = false
		dealtdamage = false
		slimestates()

func _on_box_body_entered(body: CharacterBody2D) -> void:
	#when hitbox collides with player, recoil away from the player and deal damage to the player
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a slime")
		dealtdamage = true
		body.hurt_player(damage, position.x, position.y)
		state = "recoil"
		slimestates()

	#when an object is thrown at the slime, play animations and kill them
func _on_hurt_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Objects") and body.get_child(2).flying:
		audio_player.stream = die_sfx
		audio_player.play()
		state = "die"
		slimestates()

#upon taking damage from the player, kill the slime
func hurt_enemy(player_damage: float):
	chaseok = false
	audio_player.stream = die_sfx
	audio_player.play()
	state = "die"
	slimestates()

func respawn() -> void:
	state = "idle"
	hitbox.disabled = false
	box.set_collision_mask_value(2, true)
	detector.set_collision_mask_value(2, true)
	slimezone.disabled = false
	slimebody.visible = true
	shader.visible = false
	position = spawn_coords
	slimestates()

func _on_timer_timeout() -> void:
	print("timer is done")
	match state:
		"detect":
			metal_gear_meme.visible = false
			state = "chase"
			target = Vector2(GlobalVariables.player_position)
		"giveup":
			state = "idle"
		"recoil":
			state = "wait"
		"wait":
			dealtdamage = false
			waittohit = false
			if chaseok:
				target = Vector2(GlobalVariables.player_position)
				state = "chase"
			elif !chaseok:
				target = Vector2.ZERO
				state = "giveup"
		"die":
			slimebody.visible = false
			shader.visible = false
			position = Vector2(5000,5000)
	slimestates()
