extends Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

var is_playing: bool = false
var testing_music: bool = false
var oneshot: bool = false

#declaring all music
var test_music = preload("res://audio/music/3-28-2019 (edm fight theme).wav")
var level1_music = load("res://audio/music/12-4-2016 - 1 (exploration theme).wav")
var death_music = preload("res://audio/music/trimmed/5-16-2018 - 1 (death theme trimmed).ogg")
var fight1_intro_music = load("res://audio/music/trimmed/11-21-2015 - 1 (fight 1 intro).ogg")
var fight1_music = load("res://audio/music/trimmed/11-21-2015 - 1 (fight 1 loop).ogg")
var memory_music = load("res://audio/music/trimmed/Damaged Mind (memory cutscene).ogg")
var moody_cutscene = preload("res://audio/music/trimmed/12-4-2018 - 2 (moody guitar).ogg")
var level2_music = load("res://audio/music/trimmed/10-6-2015 - 1 (exploration theme trimmed).ogg")
var zulie_theme = load("res://audio/music/trimmed/7-1-2018 - 1 (cutscene theme trimmed).ogg")
var fight2_intro_music = load("res://audio/music/trimmed/3-3-2017 - 1 (fight 2 intro).ogg")
var fight2_music = load("res://audio/music/trimmed/3-3-2017 - 1 (fight 2 loop).ogg")
var bass_swell = load("res://audio/music/BassSwellLoud.ogg")
var corrupt_town_music = load("res://audio/music/Retro Mystic (warped v2).ogg")
var town_music = load("res://audio/music/Retro Mystic.ogg")
var damien_theme = load("res://audio/music/Indecision.ogg")
var level3_music = load("res://audio/music/12-4-2016 - 1 (final area theme).ogg")
var finalboss_intro_1 = load("res://audio/music/trimmed/1-1-2018 - 1 (final boss intro 1).ogg")
var finalboss_intro_2 = load("res://audio/music/trimmed/1-1-2018 - 1 (final boss intro 2).ogg")
var finalboss_music = load("res://audio/music/trimmed/1-1-2018 - 1 (final boss loop).ogg")
var ending_part1 = load("res://audio/music/trimmed/8-31-2017 - 2 (ending theme part 1).ogg")
var ending_part2 = load("res://audio/music/trimmed/8-31-2017 - 2 (ending theme main).ogg")

func ready() -> void:
	is_playing = false

func music_stop() -> void:
	bgm_player.stop()
	is_playing = false

func test_music_stop() -> void:
	if testing_music:
		bgm_player.stop()
		is_playing = false
		testing_music = false

func vol_reset() -> void:
	animation_player.play("RESET")
	oneshot = false
	is_playing = false

func music_fadein() -> void:
	animation_player.play("fade_in")

func music_fadeout_slow() -> void:
	animation_player.play("fadeout_slow")
	timer.start(5)

func music_fadeout_fast() -> void:
	animation_player.play("fadeout_fast")
	timer.start(3)

func test_music_settings() -> void:
	if !is_playing:
		bgm_player.stream = test_music
		bgm_player.play()
		is_playing = true
		testing_music = true

func play_level1_music() -> void:
	if !is_playing:
		bgm_player.stream = level1_music
		bgm_player.play()
		is_playing = true

func play_level2_music() -> void:
	if !is_playing:
		bgm_player.stream = level2_music
		bgm_player.play()
		is_playing = true

func play_death_music() -> void:
	if !is_playing:
		bgm_player.stream = death_music
		bgm_player.play()
		is_playing = true

func play_fight1_intro() -> void:
	if !is_playing:
		bgm_player.stream = fight1_intro_music
		bgm_player.play()
		is_playing = true

func play_fight1_music() -> void:
	if !is_playing:
		bgm_player.stream = fight1_music
		bgm_player.play()
		is_playing = true
	else:
		bgm_player.stream = fight1_music

func play_memory_music() -> void:
	if !is_playing:
		bgm_player.stream = memory_music
		bgm_player.play()
		is_playing = true

func play_moody_music() -> void:
	if !is_playing:
		bgm_player.stream = moody_cutscene
		bgm_player.play()
		is_playing = true

func play_zulie_theme() -> void:
	if !is_playing:
		bgm_player.stream = zulie_theme
		bgm_player.play()
		is_playing = true

func play_fight2_intro() -> void:
	if !is_playing:
		bgm_player.stream = fight2_intro_music
		bgm_player.play()
		is_playing = true

func play_fight2_music() -> void:
	if !is_playing:
		bgm_player.stream = fight2_music
		bgm_player.play()
		is_playing = true
	else:
		bgm_player.stream = fight2_music

func play_bass_swell() -> void:
	if !is_playing:
		bgm_player.stream = bass_swell
		bgm_player.play()
		is_playing = true

func play_corrupt_town_music() -> void:
	if !is_playing:
		bgm_player.stream = corrupt_town_music
		bgm_player.play()
		is_playing = true

func play_town_music() -> void:
	if !is_playing:
		bgm_player.stream = town_music
		bgm_player.play()
		is_playing = true

func play_damien_theme() -> void:
	if !is_playing:
		bgm_player.stream = damien_theme
		bgm_player.play()
		is_playing = true

func play_level3_music() -> void:
	if !is_playing:
		bgm_player.stream = level3_music
		bgm_player.play()
		is_playing = true

func play_finalboss_intro_1() -> void:
	if !is_playing:
		bgm_player.stream = finalboss_intro_1
		bgm_player.play()
		is_playing = true

func play_finalboss_intro_2() -> void:
	bgm_player.stop()
	bgm_player.stream = finalboss_intro_2
	bgm_player.play()

func play_finalboss_music() -> void:
	if !is_playing:
		bgm_player.stream = finalboss_music
		bgm_player.play()
		is_playing = true

func play_ending_part1() -> void:
	if !is_playing:
		bgm_player.stream = ending_part1
		bgm_player.play()
		is_playing = true

func play_ending_part2() -> void:
	if !is_playing:
		bgm_player.stream = ending_part2
		bgm_player.play()
		is_playing = true
		oneshot = true

func _on_audio_stream_player_finished() -> void:
	if !oneshot:
		#if bgm_player.stream == fight1_intro_music:
			#play_fight1_music()
		match bgm_player.stream:
			fight1_intro_music:
				play_fight1_music()
			fight2_intro_music:
				play_fight2_music()
		bgm_player.play()

#stops music after a timeout
func _on_timer_timeout() -> void:
	bgm_player.stop()
	is_playing = false
