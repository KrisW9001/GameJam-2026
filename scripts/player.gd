extends CharacterBody2D
#movement stats-
#basic movement stats are for simply moving the control stick
#roll movement stats are for when the player uses their dodge roll
#attack movement stats are for when a small movement is made for visual flair, or as an integral part to how the attack works
const accel: int = 20
const max_speed: int = 215
var sprint_speed: int = 350
var sprint_accel: int = 5
const atk1_max_spd: int = 7
const roll_max_spd: int = 220
const friction: int = 50
const recoil: int = 2
const atk1_friction: int = 100
const roll_fricton: int = 75
enum facing_direction {up, down, left, right}
var atk_vec: Vector2 

#stats for objects and interacting with them
var throw_strength: float = -800
var object_hovering: Array[Node2D] = []
var held_object: Node2D = null
var object_facing: float = 0
var x_drop: float = 0
var y_drop: float = 0

@export var facing: facing_direction
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var emote: AnimatedSprite2D = $emote
@onready var facinglabel: Label = $"../testing visuals/facinglabel"
@onready var healtutorial: Label = $"../testing visuals/healtutorial"
@onready var healthtutorial: Label = $"../testing visuals/healthtutorial"
@onready var inputvisual: Label = $"../testing visuals/inputvisual"
@onready var inspect_prompt: Sprite2D = $InspectPrompt
@onready var box_control: AnimationPlayer = $BoxControl
@onready var col_box: CollisionShape2D = $CollisionShape2D
@onready var grab_box: CollisionShape2D = $Area2D/GrabBox
@onready var atk_box: CollisionShape2D = $Area2D/AtkBox
@onready var respawn_anchor: Area2D = $"../triggers/RespawnAnchor"
@onready var audio_player: AudioStreamPlayer = $AudioPlayer
@onready var dmg_shader_1: ColorRect = $damage1
@onready var dmg_shader_2: ColorRect = $damage2
@onready var deathscreen: ColorRect = $deathscreen
@onready var heal_timer: Timer = $HealTimer

#variables to control whether or not the player input has influence over stuff (IE: removing the ability to move the player character during cutscenes)
var debug_mode: bool = false
var attacking: bool = false
var grabbing: bool = false
var can_move: bool = true
var can_throw: bool = false
var run: bool = false
var damaged: bool = false
var dead: bool = false
var can_inspect: bool = false
var can_talk_v: bool = false

#defining variables to be used when calculating damage taken
var max_health: int = 3
var health: int = 3
var damage: int = 1
var enemy_pos_x: float
var enemy_pos_y: float
var dist_diff_x: float
var dist_diff_y: float
#used for displaying values on labels in the first area to tutorialize certain mechanics
var fuckassvariable = 0
var fuckassdisplay = str(fuckassvariable)

#variables for sfx
var is_playing: bool = false
var atk_sfx = preload("res://audio/sfx/Sword 2.wav")
var grab_sfx = preload("res://audio/sfx/Hit 2.wav")
var throw_sfx = preload("res://audio/sfx/Laser Shot.wav")
var dmg_sfx = preload("res://audio/sfx/Door Close Big.wav")
var die_sfx = preload("res://audio/sfx/Explosion.wav")

func ready() -> void:
	print("readying")
	facing = 1
	dmg_shader_1.visible = false
	dmg_shader_2.visible = false
	deathscreen.visible = false
	inspect_prompt.visible = false
	anim_sprite.play("idle_down")
	#put new thing here
	health = 3
	await get_tree().create_timer(1).timeout
	dead = false
	can_move = true
	col_box.disabled = false
	z_index = 2
	#GlobalVariables.menumode = false

func _physics_process(delta: float) -> void:
#interpret movement binds as character movement
	GlobalVariables.player_position = position
	#if the player is in a cutscene and supposed to be moving, turn off all physics processes
	if !GlobalVariables.player_goto_active and !GlobalVariables.cutscenemode:
		#set the global variable of the player's position to the player's coordinates
		#read values of health and heal_timer and display things on labels accordingly. this should only be present in the first area and is meant to tutorialize the health and healing mechanics
		if healtutorial and fuckassdisplay:
			healtutorial.text = fuckassdisplay
			match health:
				3:
					healthtutorial.text = "3"
					fuckassvariable = 0
					fuckassdisplay = str(fuckassvariable)
				2:
					healthtutorial.text = "2"
					fuckassvariable += 1
					fuckassdisplay = str(fuckassvariable)
				1:
					healthtutorial.text = "1"
					fuckassvariable += 1
					fuckassdisplay = str(fuckassvariable)
				0:
					healthtutorial.text = "0"
					fuckassvariable = 0
					fuckassdisplay = str(fuckassvariable)
		var input = Vector2(
			Input.get_action_strength("right_input") - Input.get_action_strength("left_input"), Input.get_action_strength("down_input") - Input.get_action_strength("up_input")
		).normalized()
		var inputstring = str(input)
		if inputvisual:
			inputvisual.text = inputstring
		
		#replaces the above input vector2 during a cutscene where the player needs to move to a location
		
		#animate the player depending on which direction they should be facing and whether or not they are moving or carrying an object
		if input and can_move:
			if !held_object and !run:
				if input.y < -0.5:
					facing = 0
					anim_sprite.play("walk_up")
				elif input.y > 0.5:
					facing = 1
					anim_sprite.play("walk_down")
				elif input.x < 0:
					facing = 2
					anim_sprite.play("walk_left")
				elif input.x > 0:
					facing = 3
					anim_sprite.play("walk_right")
			elif !held_object and run:
				if input.y < -0.5:
					facing = 0
					anim_sprite.play("run_up")
				elif input.y > 0.5:
					facing = 1
					anim_sprite.play("run_down")
				elif input.x < 0:
					facing = 2
					anim_sprite.play("run_left")
				elif input.x > 0:
					facing = 3
					anim_sprite.play("run_right")
			elif held_object and !run:
				if input.y < -0.5:
					facing = 0
					anim_sprite.play("carry_up")
				elif input.y > 0.5:
					facing = 1
					anim_sprite.play("carry_down")
				elif input.x < 0:
					facing = 2
					anim_sprite.play("carry_left")
				elif input.x > 0:
					facing = 3
					anim_sprite.play("carry_right")
			elif held_object and run:
				if input.y < -0.5:
					facing = 0
					anim_sprite.play("carry_run_up")
				elif input.y > 0.5:
					facing = 1
					anim_sprite.play("carry_run_down")
				elif input.x < 0:
					facing = 2
					anim_sprite.play("carry_run_left")
				elif input.x > 0:
					facing = 3
					anim_sprite.play("carry_run_right")
		elif can_move and !attacking and !grabbing and !GlobalVariables.menumode:
			if !held_object:
				match facing:
					0:
						anim_sprite.play("idle_up")
					1:
						anim_sprite.play("idle_down")
					2:
						anim_sprite.play("idle_left")
					3:
						anim_sprite.play("idle_right")
			elif held_object:
				match facing:
					0:
						anim_sprite.play("idle_hold_up")
					1:
						anim_sprite.play("idle_hold_down")
					2:
						anim_sprite.play("idle_hold_left")
					3:
						anim_sprite.play("idle_hold_right")
		
		var lerp_weight = delta * (accel if input else friction)
		var lerp_weight_run = delta * (sprint_accel if input else friction)
		#var lerp_weight_cutscene = (delta * accel)
		if can_move and !attacking and !grabbing and !GlobalVariables.menumode:
			if !run:
				velocity = lerp(velocity, input * max_speed, lerp_weight)
			elif run:
				velocity = lerp(velocity, input * sprint_speed, lerp_weight_run)
		
		object_facing = facing
		#print(can_move)
		#code for interactions with objects that can be picked up when pressing grab
		if grabbing:
			if object_hovering.size() > 0:
				var object = object_hovering[0]
				#pick up an object
				held_object = object
				object.get_node("ObjectLogic1").pickup(self)
				grabbing = false
			elif held_object:
				#drop the object you're holding, and play the appropriate dropping animation
				print("dropping")
				match facing:
					0:
						x_drop = 0
						y_drop = -25
						anim_sprite.play("drop_up")
					1:
						x_drop = 0
						y_drop = 25
						anim_sprite.play("drop_down")
					2:
						x_drop = -25
						y_drop = 0
						anim_sprite.play("drop_left")
					3:
						x_drop = 25
						y_drop = 0
						anim_sprite.play("drop_right")
				held_object.get_node("ObjectLogic1").drop(global_position,x_drop,y_drop)
				box_control.play("RESET")
				held_object.get_node("ObjectLogic1").cooldown()
				held_object = null
				can_throw = false
		
		#drop whatever you're holding when entering a cutscene
		if held_object and GlobalVariables.cutscenemode:
			held_object.get_node("ObjectLogic1").drop(global_position,x_drop,y_drop)
			box_control.play("RESET")
			held_object.get_node("ObjectLogic1").cooldown()
			held_object = null
			can_throw = false
		
		#if the player is taking damage, slide them away from the enemy that damaged them
		if damaged and !dead:
			position.x = move_toward(position.x, enemy_pos_x,max_speed * -delta)
			position.y = move_toward(position.y, enemy_pos_y,max_speed * -delta)
		
		move_and_slide()
		
		#debug code for a label to show which direction the player is facing
		if facinglabel:
			match facing:
				0:
					facinglabel.text = ("up")
				1:
					facinglabel.text = ("down")
				2:
					facinglabel.text = ("left")
				3:
					facinglabel.text = ("right")
	if GlobalVariables.player_goto_active and GlobalVariables.cutscenemode:
		position.x =  move_toward(position.x, GlobalVariables.player_goto_coords.x, max_speed * delta)
		position.y =  move_toward(position.y, GlobalVariables.player_goto_coords.y, max_speed * delta)

#controls actions performed by the player when inputs are performed
func _input(_event: InputEvent) -> void:
	#controls animations and hitboxes for the basic attack
	if !GlobalVariables.cutscenemode and !GlobalVariables.player_goto_active:
		if Input.is_action_just_pressed("attack") and !attacking and !grabbing and !GlobalVariables.menumode and !dead:
			#if you're not holding an object, do a basic attack
			if !held_object:
				#when attack is pressed, use the current control stick values to create a direction that the attack will move in
				var atk_vec = Vector2(
				Input.get_action_strength("right_input") - Input.get_action_strength("left_input"), Input.get_action_strength("down_input") - Input.get_action_strength("up_input")
			).normalized()
				attacking = true
				can_move = false
				velocity = Vector2(0,0)
				is_playing = true
				match facing:
					0:
						anim_sprite.play("attack_up")
						box_control.play("atk_up")
						await get_tree().create_timer(0.25).timeout
						audio_player.stream = atk_sfx
						audio_player.play()
						if atk_vec:
							velocity = lerp(velocity, atk_vec * atk1_max_spd, atk1_friction)
						else:
							velocity = lerp(velocity, Vector2(0,-1) * atk1_max_spd, atk1_friction)
						await get_tree().create_timer(0.04).timeout
						velocity = Vector2(0,0)
						#below line was previously await get_tree().create_timer(0.21).timeout
						await get_tree().create_timer(0.25).timeout
						box_control.play("RESET")
						attacking = false
						can_move = true
						is_playing = false
					1:
						anim_sprite.play("attack_down")
						box_control.play("atk_down")
						await get_tree().create_timer(0.25).timeout
						audio_player.stream = atk_sfx
						audio_player.play()
						if atk_vec:
							velocity = lerp(velocity, atk_vec * atk1_max_spd, atk1_friction)
						else:
							velocity = lerp(velocity, Vector2(0,1) * atk1_max_spd, atk1_friction)
						await get_tree().create_timer(0.04).timeout
						velocity = Vector2(0,0)
						await get_tree().create_timer(0.25).timeout
						box_control.play("RESET")
						attacking = false
						can_move = true
						is_playing = false
					2:
						anim_sprite.play("attack_left")
						box_control.play("atk_left")
						await get_tree().create_timer(0.25).timeout
						audio_player.stream = atk_sfx
						audio_player.play()
						if atk_vec:
							velocity = lerp(velocity, atk_vec * atk1_max_spd, atk1_friction)
						else:
							velocity = lerp(velocity, Vector2(-1,0) * atk1_max_spd, atk1_friction)
						await get_tree().create_timer(0.04).timeout
						velocity = Vector2(0,0)
						await get_tree().create_timer(0.25).timeout
						box_control.play("RESET")
						attacking = false
						can_move = true
						is_playing = false
					3:
						anim_sprite.play("attack_right")
						box_control.play("atk_right")
						await get_tree().create_timer(0.25).timeout
						audio_player.stream = atk_sfx
						audio_player.play()
						if atk_vec:
							velocity = lerp(velocity, atk_vec * atk1_max_spd, atk1_friction)
						else:
							velocity = lerp(velocity, Vector2(1,0) * atk1_max_spd, atk1_friction)
						await get_tree().create_timer(0.04).timeout
						velocity = Vector2(0,0)
						await get_tree().create_timer(0.25).timeout
						box_control.play("RESET")
						attacking = false
						can_move = true
						is_playing = false
			#if holding an object, throw it
			elif held_object:
				#var throw_vec = Vector2(
				#Input.get_action_strength("right_input") - Input.get_action_strength("left_input"), Input.get_action_strength("down_input") - Input.get_action_strength("up_input")
			#).normalized()
				attacking = true
				can_move = false
				velocity = Vector2.ZERO
				match facing:
					0:
						anim_sprite.play("throw_up")
						var throw_x = 0
						var throw_y = throw_strength
						held_object.get_node("ObjectLogic1").throw(throw_x,throw_y)
						held_object = null
						audio_player.stream = throw_sfx
						audio_player.play()
						await get_tree().create_timer(0.1).timeout
						attacking = false
						can_move = true
					1:
						anim_sprite.play("throw_down")
						var throw_x = 0
						var throw_y = throw_strength * -1
						held_object.get_node("ObjectLogic1").throw(throw_x,throw_y)
						held_object = null
						audio_player.stream = throw_sfx
						audio_player.play()
						await get_tree().create_timer(0.1).timeout
						attacking = false
						can_move = true
					2:
						anim_sprite.play("throw_left")
						var throw_x = throw_strength
						var throw_y = 0
						held_object.get_node("ObjectLogic1").throw(throw_x,throw_y)
						held_object = null
						audio_player.stream = throw_sfx
						audio_player.play()
						await get_tree().create_timer(0.1).timeout
						attacking = false
						can_move = true
					3:
						anim_sprite.play("throw_right")
						var throw_x = throw_strength * -1
						var throw_y = 0
						held_object.get_node("ObjectLogic1").throw(throw_x,throw_y)
						held_object = null
						audio_player.stream = throw_sfx
						audio_player.play()
						await get_tree().create_timer(0.1).timeout
						attacking = false
						can_move = true
				can_throw = false
		
		#controls animations and hitboxes for grabbing
		if Input.is_action_just_pressed("grab") and !grabbing and !attacking and !GlobalVariables.menumode and !dead:
			grabbing = true
			can_move = false
			velocity = Vector2(0,0)
			match facing:
				0:
					anim_sprite.play("grab_up")
					box_control.play("grab_up")
					await get_tree().create_timer(0.3).timeout
					grabbing = false
					can_move = true
					box_control.play("RESET")
				1:
					anim_sprite.play("grab_down")
					box_control.play("grab_down")
					await get_tree().create_timer(0.3).timeout
					grabbing = false
					can_move = true
					box_control.play("RESET")
				2:
					anim_sprite.play("grab_left")
					box_control.play("grab_left")
					await get_tree().create_timer(0.3).timeout
					grabbing = false
					can_move = true
					box_control.play("RESET")
				3:
					anim_sprite.play("grab_right")
					box_control.play("grab_right")
					await get_tree().create_timer(0.3).timeout
					grabbing = false
					can_move = true
					box_control.play("RESET")
		
		#toggle running if the run button is held
		if Input.is_action_pressed("run"):
			run = true
		else:
			run = false
		
		#toggle pause
		if Input.is_action_just_pressed("pause"):
			print("pausing")
			PauseMenu.create()
		
		#debug mode
		if Input.is_action_just_pressed("enhance") and !debug_mode:
			print("debug mode on")
			sprint_speed = 600
			sprint_accel = 100
			set_collision_layer_value(2, false)
			set_collision_mask_value(1, false)
			debug_mode = true
		elif Input.is_action_just_pressed("enhance") and debug_mode:
			print("debug mode off")
			sprint_speed = 350
			sprint_accel = 5
			set_collision_layer_value(2, true)
			set_collision_mask_value(1, true)
			debug_mode = false
		
		#trigger inspect dialogue if inside an inspect area
		if Input.is_action_just_pressed("interact"):
			if can_inspect and !GlobalVariables.menumode and !dead:
				velocity = Vector2.ZERO
				match facing:
					0:
						anim_sprite.play("idle_up")
					1:
						anim_sprite.play("idle_down")
					2:
						anim_sprite.play("idle_left")
					3:
						anim_sprite.play("idle_right")
				inspect_prompt.visible = false
				GlobalVariables.cutscenemode = true
				TalkScenes.protag_talk.start()
				print("starting dialogue")
			elif can_talk_v and !GlobalVariables.menumode and !dead and !can_inspect:
				velocity = Vector2.ZERO
				match facing:
					0:
						anim_sprite.play("idle_up")
					1:
						anim_sprite.play("idle_down")
					2:
						anim_sprite.play("idle_left")
					3:
						anim_sprite.play("idle_right")
				inspect_prompt.visible = false
				GlobalVariables.cutscenemode = true
				TalkScenes.vagabond_talk.start()
				pass
		
		#debug function
		#if Input.is_action_just_pressed("enhance"):
			#GlobalVariables.player_goto_coords = Vector2(100,-200)

#pick up objects when grabbox is active, deal damage when attack box is active
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("can_pickup") and grabbing:
		if !held_object or held_object != body:
			is_playing = true
			audio_player.stream = grab_sfx
			audio_player.play()
			if object_hovering.has(body):
				object_hovering.erase(body)
			object_hovering.push_front(body)
	if body.is_in_group("enemies"):
		if attacking:
			print("hit an enemy with a punch")
			body.hurt_enemy(damage)
	if body.is_in_group("boss"):
		if attacking:
			print("hit a boss with a punch")
			body.hurt_boss(damage * 2)

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("can_pickup"):
		object_hovering.erase(body)

func hurt_player(damage: int, enemy_x: float, enemy_y: float, dist_x: float, dist_y: float) -> void:
	match health:
		3:
			dmg_shader_1.visible = true
			dmg_shader_2.visible = false
			health -= 1
			audio_player.stream = dmg_sfx
			TheCamera.dmg_shake()
			audio_player.play()
			can_move = false
			damaged = true
			enemy_pos_x = enemy_x
			enemy_pos_y = enemy_y
			dist_diff_x = dist_x
			dist_diff_y = dist_y
			TheCamera.screentint(1)
			heal_timer.start()
			await get_tree().create_timer(0.3).timeout
			can_move = true
			damaged = false
		2:
			dmg_shader_1.visible = false
			dmg_shader_2.visible = true
			health -= 1
			audio_player.stream = dmg_sfx
			TheCamera.dmg_shake()
			audio_player.play()
			can_move = false
			damaged = true
			enemy_pos_x = enemy_x
			enemy_pos_y = enemy_y
			dist_diff_x = dist_x
			dist_diff_y = dist_y
			heal_timer.start()
			await get_tree().create_timer(0.3).timeout
			can_move = true
			damaged = false
			TheCamera.screentint(2)
		1:
			MusicController.music_stop()
			health -= 1
			heal_timer.stop()
			dmg_shader_1.visible = false
			dmg_shader_2.visible = false
			TheCamera.screentint(0)
			velocity = Vector2.ZERO
			audio_player.stream = die_sfx
			audio_player.play()
			box_control.play("RESET")
			anim_sprite.play("die")
			can_move = false
			attacking = false
			grabbing = false
			can_throw = false
			dead = true
			col_box.disabled = true
			grab_box.disabled = true
			atk_box.disabled = true
			dmg_shader_1.visible = false
			dmg_shader_2.visible = false
			deathscreen.visible = true
			z_index = 4
			await get_tree().create_timer(3).timeout
			MusicController.play_death_music()
			GameOver.death_menu()
			print(z_index)

#when the heal timer ends, increase the player's health
func _on_heal_timer_timeout() -> void:
	if health < 3 and !dead:
		match health:
			1:
				health += 1
				heal_timer.start()
				dmg_shader_1.visible = true
				dmg_shader_2.visible = false
				TheCamera.screentint(1)
				fuckassvariable = 0
			2:
				health += 1
				heal_timer.stop()
				dmg_shader_1.visible = false
				dmg_shader_2.visible = false
				TheCamera.screentint(0)
				fuckassvariable = 0

#respawn the player, and return all state-related variables to normal
func respawn() -> void:
	print("respawning")
	if GlobalVariables.cur_respawn != Vector2.ZERO:
		position = GlobalVariables.cur_respawn
	else:
		position = Vector2(0,0)
	facing = 1
	dmg_shader_1.visible = false
	dmg_shader_2.visible = false
	deathscreen.visible = false
	anim_sprite.play("idle_down")
	health = 3
	await get_tree().create_timer(1).timeout
	dead = false
	can_move = true
	col_box.disabled = false
	z_index = 2
	#GlobalVariables.menumode = false

#pause damage shaders to avoid jank
func pause_shaders() -> void:
	dmg_shader_1.modulate = Color(1.0, 1.0, 1.0, 0.0)
	dmg_shader_2.modulate = Color(1.0, 1.0, 1.0, 0.0)
	await get_tree().create_timer(0.3).timeout
	dmg_shader_1.modulate = Color(1.0, 1.0, 1.0)
	dmg_shader_2.modulate = Color(1.0, 1.0, 1.0)

#cutscene stuff
func iliketospin() -> void:
	anim_sprite.play("spin")

func item_pose() -> void:
	anim_sprite.play("item_get")

#the next two are used in memory cutscenes
func struggle() -> void:
	anim_sprite.play("struggle")

func recover() -> void:
	anim_sprite.modulate = Color("ffffffff")
	anim_sprite.play("idle_down")

func kill_freeze() -> void:
	anim_sprite.modulate = Color("000000ff")
	anim_sprite.pause()
	deathscreen.visible = true

#use emote bubble above players head
func emote_exclaim() -> void:
	emote.visible = true
	emote.play("exclamation")
	await get_tree().create_timer(0.5).timeout
	emote.visible = false

func emote_question() -> void:
	emote.visible = true
	emote.play("question")
	await get_tree().create_timer(0.5).timeout
	emote.visible = false

func walk_r() -> void:
	anim_sprite.play("walk_right")

func idle_r() -> void:
	anim_sprite.play("idle_right")

#stop moving instantly.
func stop_moving() -> void:
	velocity = Vector2.ZERO
	can_move = false

func end_anim() -> void:
	#GlobalVariables.player_goto_active = false
	print("ending animation")
	facing = 1
	anim_sprite.play("idle_down")
	can_move = true
