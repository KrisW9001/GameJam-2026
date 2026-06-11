extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	MusicController.vol_reset()
	MusicController.play_corrupt_town_music()
	town_tele()

func town_tele() -> void:
	match GlobalVariables.town_room:
		"door":
			player.global_position = Vector2(0, 0)
			TheCamera.snap(Vector2(0,0))
		"ladder":
			player.global_position = Vector2(750, -650)
			TheCamera.snap(Vector2(750,-650))
