extends Node2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	town_tele()

func town_tele() -> void:
	match GlobalVariables.town_room:
		"down_ladder":
			player.global_position = Vector2(-407, -122)
		"up_ladder":
			player.global_position = Vector2(450, -250)
