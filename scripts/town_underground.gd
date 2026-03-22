extends Node2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	town_tele()

func town_tele() -> void:
	match GlobalVariables.town_room:
		"Passage":
			player.global_position = Vector2(0,-100)
			TheCamera.snap(Vector2(0, -1))
		"storeroom":
			player.global_position = Vector2(450,-100)
			TheCamera.snap(Vector2(450, -1))
		"zulie":
			player.global_position = Vector2(-750,1379.0)
			TheCamera.snap(Vector2(-750,1379.0))
