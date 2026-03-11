extends Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

var is_playing: bool = false
var testing_music: bool = false
var oneshot: bool = false

#declaring all music
var test_music = preload("res://audio/music/3-28-2019 (edm fight theme).wav")
var level1_music = preload("res://audio/music/12-4-2016 - 1 (exploration theme).wav")
var death_music = preload("res://audio/music/trimmed/5-16-2018 - 1 (death theme trimmed).ogg")
var fight1_intro_music = load("res://audio/music/trimmed/11-21-2015 - 1 (fight 1 intro).ogg")
var fight1_music = load("res://audio/music/trimmed/11-21-2015 - 1 (fight 1 loop).ogg")
var memory_music = load("res://audio/music/trimmed/Damaged Mind (memory cutscene).ogg")

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

func _on_audio_stream_player_finished() -> void:
	if !oneshot:
		if bgm_player.stream == fight1_intro_music:
			play_fight1_music()
		bgm_player.play()

#stops music after a timeout
func _on_timer_timeout() -> void:
	bgm_player.stop()
	is_playing = false
