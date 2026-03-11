extends Node

var world1_music = load("res://assets/Ambient Puzzle Music SFX Pack/Level 7 (Loop).ogg")
var title_music = load("res://assets/Ambient Puzzle Music SFX Pack/Level 8 (Loop).ogg")
var world2_music = load("res://assets/Ambient Puzzle Music SFX Pack/Level 6 (Loop).ogg")
var world3_music = load("res://assets/Ambient Puzzle Music SFX Pack/Level 5 (Loop).ogg")
var mystery_music = load("res://assets/Ambient Puzzle Music SFX Pack/Level 4 (Loop).ogg")
var prologue_music = load("res://assets/Fantasy Towns Music Pack/Whimsical Town (Loop).ogg")
var test_music = load("res://assets/MY ASSETS evil emoji/music/townprolly2.ogg")
@onready var animation_player = $AnimationPlayer
@onready var fades: AnimationPlayer = $fades

var is_playing = false

func denial_button():
	animation_player.play("buttondeny")

func play_world1_music():
	fades.play("bring_me_to_life")
	$Music.stream = world1_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false
	
func play_world2_music():
	fades.play("bring_me_to_life")
	$Music.stream = world2_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false

func play_prologue_music():
	fades.play("fade_in_slow")
	$Music.stream = prologue_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false

func play_titlescreen_music():
	$Music.stream = title_music
	$Music.play()
	if !VariableStorage.title_music_playing == true:
		fades.play("fade_in_slow")
	is_playing = true
	VariableStorage.title_music_playing = true
	
func play_world3_music():
	fades.play("bring_me_to_life")
	$Music.stream = world3_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false
	
func play_mystery_music():
	fades.play("bring_me_to_life")
	$Music.stream = mystery_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false
	
func play_test_music():
	fades.play("bring_me_to_life")
	$Music.stream = test_music
	$Music.play()
	is_playing = true
	VariableStorage.title_music_playing = false
	
func pause_song():
	$Music.stream_paused = true
	is_playing = false
	
func unpause_song():
	$Music.stream_paused = false
	is_playing = true

func fade_out_fast():
	fades.stop()
	fades.play("fade_out_fast")

func fade_in_fast():
	fades.stop()
	fades.play("fade_in_slow")

func fade_out_slow():
	fades.stop()
	fades.play("fade_out_slow")

func no_sound():
	fades.stop()
	fades.play("no_sound")
