extends Area2D

@export var whattotrigger: int
var is_playing: bool = false


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
				3:
					MusicController.music_fadein()
					MusicController.play_level2_music()
				4:
					MusicController.music_fadein()
					MusicController.play_corrupt_town_music()
				5:
					MusicController.music_fadein()
					MusicController.play_level3_music()
