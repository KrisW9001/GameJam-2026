extends Node

#this script is used to determine how a cutscene plays out, by using global variables and controlling other scenes/scripts. 

var margin_x: bool = false
var margin_y: bool = false
var player_pos = GlobalVariables.player_position
var player_gtc = GlobalVariables.player_goto_coords
var player_at_coords: bool = false

#used to determine if a cutscene is currently running. used to transition between phases of a cutscene
var incut1: bool = false
var incut5: bool = false
var incut6: bool = false
var incut10: bool = false
var incut13: bool = false
var part2: bool = false

func _process(delta: float) -> void:
	if GlobalVariables.player_position == GlobalVariables.player_goto_coords:
		player_at_coords = true
	else:
		player_at_coords = false
	
	if player_at_coords and incut13:
		get_tree().call_group("Player", "idle_r")
	
	if GlobalVariables.camera_position == GlobalVariables.lock_pos and incut1 and !part2:
		#play next part of cutscene
		if !GlobalVariables.seenfirstcut:
			cutscene1_part2()
		else:
			incut1 = false
	
	#if player_at_coords and !incut10 and GlobalVariables.player_goto_active == true:
		#get_tree().call_group("Player", "idle_up")
	
	
	#if zulie finishes divekick in start of cutscene 5, start dialogue
	if GlobalVariables.zulie_position == GlobalVariables.zulie_coords and incut5 and !GlobalVariables.metzulie:
		get_tree().call_group("slime_actor", "die")
		get_tree().call_group("Zulie", "land_l")
		MusicController.music_stop()
		get_tree().call_group("meme_text", "invis")
		GlobalVariables.zulie_goto = false
		GlobalVariables.metzulie = true
		await get_tree().create_timer(1).timeout
		TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_intro.dialogue")
		TalkScenes.zulie_talk.start()
	
	if GlobalVariables.vagabond_position == GlobalVariables.vagabond_coords and incut5 and !GlobalVariables.beatsecondboss:
		get_tree().call_group("VagabondActor", "idle_l")
	
	if GlobalVariables.mage_position == GlobalVariables.mage_coords and incut6:
		get_tree().call_group("boss", "idle_l")

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
		3:
			#zulie introduction
			if !GlobalVariables.metzulie:
				cutscene5()
		4:
			#end of mage gauntlet
			if !GlobalVariables.beatsecondboss:
				cutscene7()
		5: 
			#noble introduction
			if !GlobalVariables.seennoblecut:
				cutscene10()
		6: 
			#noble pre-fight cutscene
			if !GlobalVariables.nobleprefight and !GlobalVariables.cutscenemode:
				cutscene11()
			elif GlobalVariables.nobleprefight and !GlobalVariables.cutscenemode:
				cutscene12()

func endcutscene() -> void:
	print("ending cutscene")
	incut1 = false
	incut5 = false
	incut6 = false
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
	endcutscene()
	GlobalVariables.vagabond_goto = false
	get_tree().call_group("VagabondActor", "invis")

#play special effects on a boss kill
func boss_kill() -> void:
	GlobalVariables.cutscenemode = true
	MusicController.music_stop()
	get_tree().call_group("Player", "kill_freeze")

#cutscene introducing the fighter before their boss fight
func cutscene2() -> void:
	if GlobalVariables.metfighter == false:
		GlobalVariables.cutscenemode = true
		get_tree().call_group("explosion", "play")
		get_tree().call_group("Player", "struggle")
		TheCamera.shake()
		GlobalVariables.player_goto_active = true
		GlobalVariables.player_goto_coords = Vector2(275, 250)
		await get_tree().create_timer(0.5).timeout
		TalkScenes.fighter_talk.dialogue_resource = load("res://dialogue/fighter_intro.dialogue")
		TalkScenes.fighter_talk.start()
	elif GlobalVariables.metfighter == true:
		GlobalVariables.cutscenemode = true
		get_tree().call_group("explosion", "play")
		get_tree().call_group("Player", "struggle")
		TheCamera.shake()
		GlobalVariables.player_goto_active = true
		GlobalVariables.player_goto_coords = Vector2(275, 250)
		await get_tree().create_timer(0.5).timeout
		get_tree().call_group("boss", "jump_in")
		await get_tree().create_timer(2).timeout
		MusicController.vol_reset()
		MusicController.play_fight1_intro()
		get_tree().call_group("boss", "start_fight")
		CutsceneManager.endcutscene()

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
	GlobalVariables.player_goto_coords = Vector2(2500, 450)
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/subway_warp.dialogue")
	TalkScenes.protag_talk.start()
	TheCamera.reset()

#part 2 of vagabond's post-fighter cutscene
func cutscene4_part2() -> void:
	TheCamera.transition_off()
	get_tree().call_group("Player", "idle_r")
	await get_tree().create_timer(.5).timeout
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_post_fighter_2.dialogue")
	TalkScenes.vagabond_talk.start()

#giant slime gag, plus introductory cutscene for zulie
func cutscene5() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Player", "walk_l")
	incut5 = true
	MusicController.music_stop()
	get_tree().call_group("meme_text", "visible")
	MusicController.play_fight1_intro()
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(1890, 1550)
	await get_tree().create_timer(3).timeout
	get_tree().call_group("Player", "idle_l")
	print("zulie divekick")
	get_tree().call_group("Zulie", "appear")
	GlobalVariables.zulie_goto = true
	GlobalVariables.zulie_coords = Vector2(1650, 1575)
	get_tree().call_group("Zulie", "divekick_l")

#after cutscene 5, get zulie and vagabond to stand outside the gate to the 2nd boss
func pair_togate() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().call_group("Zulie", "upright_l")
	get_tree().call_group("VagabondActor", "idle_l")
	GlobalVariables.zulie_coords = Vector2(3500, 2200)
	GlobalVariables.vagabond_coords = Vector2(3500, 1950)
	endcutscene()

#introductory cutscene for the asset mage, before their boss fight
func cutscene6() -> void:
	GlobalVariables.cutscenemode = true
	incut6 = true
	MusicController.music_stop()
	get_tree().call_group("explosion", "play")
	get_tree().call_group("Player", "emote_exclaim")
	get_tree().call_group("Player", "idle_r")
	TalkScenes.protag_talk.sfx_fire()
	GlobalVariables.zulie_coords = Vector2(3400, 2200)
	GlobalVariables.vagabond_coords = Vector2(3400, 1950)
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(3400, 2100)
	await get_tree().create_timer(1).timeout
	get_tree().call_group("boss", "walk_l")
	get_tree().call_group("boss", "tele_in")
	GlobalVariables.mage_goto = true
	GlobalVariables.mage_coords = Vector2(3700, 2100)
	TalkScenes.mage_talk.dialogue_resource = load("res://dialogue/mage_intro.dialogue")
	TalkScenes.mage_talk.start()

func cutscene6_part2() -> void:
	get_tree().call_group("boss", "tele_out")
	get_tree().call_group("Zulie", "slash_r")
	GlobalVariables.zulie_coords = Vector2(3800, 2100)
	await get_tree().create_timer(1).timeout
	get_tree().call_group("Zulie", "dash_r")
	GlobalVariables.zulie_coords = Vector2(8500, 1800)
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_boss2_start.dialogue")
	TalkScenes.vagabond_talk.start()

func cutscene6_end() -> void:
	GlobalVariables.cameralock = false
	GlobalVariables.vagabond_coords = Vector2(3100, 1900)
	get_tree().call_group("VagabondActor", "walk_l")
	GlobalVariables.player_goto_coords = Vector2(3800, 2200)
	GlobalVariables.mage_coords = Vector2(8350, 1900)
	get_tree().call_group("Player", "walk_r")
	await get_tree().create_timer(1.5).timeout
	get_tree().call_group("earthspike", "activate")
	get_tree().call_group("enemy_projectiles", "activate")
	endcutscene()

#finale cutscene for mage gauntlet sequence
func cutscene7() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("boss", "visible")
	get_tree().call_group("boss", "idle_r")
	MusicController.music_fadeout_fast()
	get_tree().call_group("enemy_projectiles", "deactivate")
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(8250, 1850)
	get_tree().call_group("Zulie", "stance_l")
	await get_tree().create_timer(1).timeout
	get_tree().call_group("boss", "shoot_r")
	get_tree().call_group("Zulie", "crouch_l")
	get_tree().call_group("explosion", "play")
	TalkScenes.protag_talk.sfx_fire()
	GlobalVariables.zulie_coords = Vector2(8550, 1700)
	await get_tree().create_timer(1).timeout
	TalkScenes.mage_talk.dialogue_resource = load("res://dialogue/mage_battle_end.dialogue")
	TalkScenes.mage_talk.start()

#sword catching sequence of mage end-of-gauntlet cutscene
func cutscene7_part2() -> void:
	get_tree().call_group("boss", "shoot_l")
	get_tree().call_group("boss", "sword_shoot_1")
	await get_tree().create_timer(0.2).timeout
	get_tree().call_group("sword", "stop_moving")
	get_tree().call_group("Player", "catch_r")
	await get_tree().create_timer(3).timeout
	get_tree().call_group("boss", "scared_l")
	get_tree().call_group("Player", "cool_toss")
	get_tree().call_group("boss", "sword_spin")

#memory cutscene for mage boss
func cutscene7_part3() -> void:
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/mage_defeated.dialogue")
	TalkScenes.protag_talk.start()

#ending cutscene for corrupted town sequence where healer dies
func cutscene8() -> void:
	GlobalVariables.cutscenemode = true
	GlobalVariables.player_goto_active = false
	get_tree().call_group("boss", "punch")
	get_tree().call_group("Player", "catch_l")
	await get_tree().create_timer(2).timeout
	GlobalVariables.healer_coords = Vector2(2300, -355)
	get_tree().call_group("Player", "cool_throw")
	get_tree().call_group("boss", "die")

#restoring the town
func cutscene9() -> void:
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(2332,-200)
	get_tree().change_scene_to_file("res://scenes/rooms/town_restored.tscn")
	get_tree().call_group("npcs", "fixed")
	TheCamera.spell_flash_off()
	await get_tree().create_timer(3)
	get_tree().call_group("Player", "idle_down")
	TalkScenes.npc_talk.dialogue_resource = load("res://dialogue/villagers_thanks.dialogue")
	TalkScenes.npc_talk.start()

#introductory cutscene for noble
func cutscene10() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Zulie", "stance_l")
	get_tree().call_group("VagabondActor", "crouch_noweapon_r")
	MusicController.music_fadeout_slow()
	GlobalVariables.player_goto_active = true
	get_tree().call_group("Player", "move_up")
	GlobalVariables.player_goto_coords = Vector2(0, -1475)
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(0,-1927)
	await get_tree().create_timer(1.7).timeout
	get_tree().call_group("Zulie", "slash_l")
	await get_tree().create_timer(.3).timeout
	get_tree().call_group("boss", "cutscene_damage")
	GlobalVariables.noble_goto = true
	GlobalVariables.noble_coords = Vector2(-150, -1927)
	await get_tree().create_timer(1).timeout
	get_tree().call_group("boss", "shoot_r")
	get_tree().call_group("earthspike", "activate")
	get_tree().call_group("Zulie", "jump_up_l")
	GlobalVariables.zulie_goto = true
	GlobalVariables.zulie_coords = Vector2(0, -2200)
	await get_tree().create_timer(.3).timeout
	get_tree().call_group("Zulie", "divekick_l")
	GlobalVariables.zulie_coords = Vector2(-150, -1927)
	await get_tree().create_timer(0.3).timeout
	get_tree().call_group("Zulie", "crouch_l")
	GlobalVariables.noble_goto = false
	GlobalVariables.noble_coords = Vector2(300, -1927)
	get_tree().call_group("boss", "warp")
	get_tree().call_group("boss", "idle_l")
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("boss", "shoot_l")
	get_tree().call_group("enemy_projectiles", "strike")
	await get_tree().create_timer(0.3).timeout
	GlobalVariables.zulie_coords = Vector2(-200, -1875)
	get_tree().call_group("Zulie", "land_r")
	GlobalVariables.noble_goto = true
	TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_noble_intro.dialogue")
	TalkScenes.zulie_talk.start()

#dialogue scene with vagabond and zulie after meeting noble
func cutscene10_part2() -> void:
	get_tree().call_group("Player", "walk_up")
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(-200, -2075)
	GlobalVariables.lock_pos = Vector2(-200,-2100)
	await get_tree().create_timer(1.75).timeout
	get_tree().call_group("Player", "idle_up")
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/protag_post_noble.dialogue")
	TalkScenes.protag_talk.start()

#cutscene for first time entering the noble boss fight
func cutscene11() -> void:
	GlobalVariables.cutscenemode = true
	get_tree().call_group("Player", "walk_up")
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(0, -2375)
	await get_tree().create_timer(1).timeout
	MusicController.music_stop()
	get_tree().call_group("Player", "idle_down")
	get_tree().call_group("earthspike", "activate")
	await get_tree().create_timer(1).timeout
	get_tree().call_group("Player", "idle_up")
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/protag_final_boss_1.dialogue")
	TalkScenes.protag_talk.start()

#quick-start for the noble boss fight after seeing the cutscene
func cutscene12() -> void:
	GlobalVariables.cutscenemode = true
	MusicController.music_stop()
	get_tree().call_group("Player", "walk_up")
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(0, -2375)
	await get_tree().create_timer(1).timeout
	MusicController.vol_reset()
	MusicController.play_finalboss_music()
	get_tree().call_group("earthspike", "activate")
	get_tree().call_group("boss", "fight_start")
	endcutscene()

#boss kill cutscene for noble boss fight
func cutscene13() -> void:
	incut13 = true
	get_tree().call_group("earthspike", "deactivate")
	GlobalVariables.noble_coords = Vector2(100, -2400)
	GlobalVariables.lock_pos = Vector2(0, -2350)
	get_tree().call_group("boss", "warp")
	get_tree().call_group("boss", "weak_l")
	get_tree().call_group("Player", "recover")
	await get_tree().create_timer(.5).timeout
	TalkScenes.noble_talk.dialogue_resource = load("res://dialogue/noble_finale_1.dialogue")
	TalkScenes.noble_talk.start()

#semi-final cutscene
func cutscene13_part2() -> void:
	incut13 = false
	get_tree().call_group("message", "appear")
	GlobalVariables.cameralock = false
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(0, -1700)
	get_tree().call_group("Player", "walk_down")
	await get_tree().create_timer(3).timeout
	get_tree().call_group("Player", "idle_up")
	await get_tree().create_timer(1).timeout
	get_tree().call_group("Player", "walk_up")
	GlobalVariables.player_goto_coords = Vector2(-150, -1850)
	await get_tree().create_timer(.5).timeout
	TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/protag_finale_4.dialogue")
	TalkScenes.protag_talk.start()

#town cutscene before credits
func cutscene14() -> void:
	TheCamera.transition_on()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/rooms/town_cutscene.tscn")
	GlobalVariables.cutscenemode = true
	GlobalVariables.player_goto_active = true
	GlobalVariables.player_goto_coords = Vector2(1727, -1000)
	TheCamera.snap(Vector2(1537.0, -602.0))
	#GlobalVariables.cameralock = true
	#GlobalVariables.lock_pos = Vector2(1537.0, -602.0)
	TheCamera.transition_off()
	await get_tree().create_timer(0.5).timeout
	TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_precredits.dialogue")
	TalkScenes.vagabond_talk.start()
