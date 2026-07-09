extends Node2D
@onready var player: CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !MusicController.is_playing:
		MusicController.music_fadein()
		MusicController.play_level1_music()
	else:
		if MusicController.bgm_player.stream != MusicController.level1_music:
			MusicController.music_stop()
			MusicController.music_fadein()
			MusicController.play_level1_music()
	teleport()

func teleport() -> void:
	match GlobalVariables.town_room:
		"main":
			player.global_position = Vector2(1050.0, 244.0)
		"collectible":
			player.global_position = Vector2(90.0, 244.0)
