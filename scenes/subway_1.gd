extends Node2D
@onready var player: CharacterBody2D = $Player

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
	#fix this later to be more in time with the transition

#used to determine where the player should spawn when entering through a zone transition
func teleport() -> void:
	match GlobalVariables.town_room:
		"start":
			player.global_position = Vector2(644, 314)
			TheCamera.snap(player.global_position)
		"platlands":
			player.global_position = Vector2(3650, 250)
			TheCamera.snap(player.global_position)
		"secret":
			player.global_position = Vector2(190, 1242)
			TheCamera.snap(player.global_position)
