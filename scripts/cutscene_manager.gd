extends Node

#this script is used to determine how a cutscene plays out, by using global variables and controlling other scenes/scripts. 

var margin_x: bool = false
var margin_y: bool = false
var player_pos = GlobalVariables.player_position
var player_gtc = GlobalVariables.player_goto_coords
var player_at_coords: bool = false

#used to determine if a cutscene is currently running. used to transition between phases of a cutscene
var incut1: bool = false
var part2: bool = false

func _process(delta: float) -> void:
	if GlobalVariables.player_position == GlobalVariables.player_goto_coords:
		player_at_coords = true
	
	if player_at_coords and incut1:
		pass
	
	if GlobalVariables.camera_position == GlobalVariables.lock_pos and incut1 and !part2:
		#play next part of cutscene
		if !GlobalVariables.seenfirstcut:
			cutscene1_part2()
		else:
			incut1 = false
			endcutscene()
	
	#start part 2 of cutscene 4
	if GlobalVariables.beatfirstboss and !part2:
		pass

#after recieving a signal from a cutscene trigger, check which cutscene is being called and reference that with global variables to determine whether or not to play a cutscene.
func checkscene(scenenumber: int) -> void:
	match scenenumber:
		0:
				pass
		1:
			#vagabond introduction
			if !GlobalVariables.seenfirstcut and !incut1:
				cutscene1()
		2: 
			#post-fighter fight
			if GlobalVariables.beatfirstboss:
				cutscene4()

func endcutscene() -> void:
	print("ending cutscene")
	part2 = false
	SaveLoad._save()
	GlobalVariables.player_goto_active = false
	GlobalVariables.cutscenemode = false
	GlobalVariables.player_goto_coords = Vector2.ZERO
	get_tree().call_group("Player", "end_anim")

#when called, start a transition to a new room
func new_room(whichroom: String) -> void:
	GlobalVariables.cutscenemode = true
	TheCamera.transition_on()
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file(whichroom)
	GlobalVariables.cont_scene = whichroom
	SaveLoad._save()
	TheCamera.reset()
	TheCamera.transition_off()
	await get_tree().create_timer(.5).timeout
	GlobalVariables.cutscenemode = false

#testing cutscene. this should never be able to trigger in the final game.
func cutscene0() -> void:
	incut1 = true
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Player", "stop_moving")
	get_tree().call_group("Player", "emote_exclaim")
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.player_goto_active = true
	get_tree().call_group("Player", "iliketospin")
	GlobalVariables.player_goto_coords = Vector2(-150,-500)

#introductory cutscene for the vagabond.
func cutscene1() -> void:
	incut1 = true
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Player", "stop_moving")
	get_tree().call_group("Player", "emote_question")
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.player_goto_active = true
	get_tree().call_group("Player", "move_r")
	get_tree().call_group("VagabondActor", "idle_r")
	GlobalVariables.player_goto_coords = Vector2(347, 1200)
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(855,1279)

func cutscene1_part2() -> void:
	part2 = true
	print("starting cutscene 1 part 2")
	get_tree().call_group("VagabondActor", "attack_slow_r")
	await get_tree().create_timer(0.4).timeout
	get_tree().call_group("Player", "idle_r")
	get_tree().call_group("slimeactor", "die")
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("VagabondActor", "idle_r")
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabondintro.dialogue")
	TalkScenes.vagabond_talk.start()

func vagabond_offscreen() -> void:
	get_tree().call_group("VagabondActor", "walk_r")
	GlobalVariables.vagabond_goto = true
	GlobalVariables.vagabond_coords = Vector2(2000, 1338)
	await get_tree().create_timer(1).timeout
	GlobalVariables.vagabond_goto = false
	get_tree().call_group("VagabondActor", "invis")

#play special effects on a boss kill
func boss_kill() -> void:
	GlobalVariables.cutscenemode = true
	MusicController.music_stop()
	get_tree().call_group("Player", "kill_freeze")

#cutscene introducing the fighter before their boss fight
func cutscene2() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("explosion", "play")
	get_tree().call_group("Player", "struggle")
	TheCamera.shake()
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(275, 250)
	await get_tree().create_timer(0.5).timeout
	TalkScenes.fighter_talk.start()

#post-fight memory cutscene after defeating the fighter
func cutscene3() -> void:
	get_tree().call_group("Player", "struggle")
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/fighter_defeated.dialogue")
	TalkScenes.protag_talk.start()

#approaching door after beating the fighter
func cutscene4() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Player", "stop_moving")
	get_tree().call_group("Player", "emote_exclaim")
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("Player", "iliketospin")
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(400, 400)
	get_tree().call_group("VagabondActor", "appear")
	GlobalVariables.vagabond_goto = true
	GlobalVariables.vagabond_coords = Vector2(700, 350)
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("VagabondActor", "walk_r")
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_post_fighter.dialogue")
	TalkScenes.vagabond_talk.start()

#warp to intro of subway 1 after fighter boss
func subway_warp() -> void:
	TheCamera.transition_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/rooms/subway1.tscn")
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/subway_warp.dialogue")
	TalkScenes.protag_talk.start()
	TheCamera.reset()
	GlobalVariables.player_goto_coords = Vector2(2500, 450)

#part 2 of vagabond's post-fighter cutscene
func cutscene4_part2() -> void:
	TheCamera.transition_off()
	get_tree().call_group("Player", "idle_r")
	await get_tree().create_timer(.5).timeout
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_post_fighter_2.dialogue")
	TalkScenes.vagabond_talk.start()
