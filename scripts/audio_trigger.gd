extends Area2D

@export var whattotrigger: int
var is_playing: bool = false

#declaring what songs are
var level1_music = preload("res://audio/music/12-4-2016 - 1 (exploration theme).wav")

func ready() -> void:
	MusicController.clear()

#change this later to be conditional based on audio trigger's unique output variables
func _on_body_entered(body: CharacterBody2D) -> void:
	if !MusicController.is_playing:
		if body.is_in_group("Player"):
			match whattotrigger:
				0:
					MusicController.music_fadein()
					MusicController.play_level1_music()
				1:
					MusicController.music_fadeout_slow()
				2: 
					MusicController.music_fadeout_fast()
