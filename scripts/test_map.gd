extends Node2D
@onready var vagabond: CharacterBody2D = $Vagabond
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.seenfirstcut:
		vagabond.global_position = Vector2(-1000,-2000)
	teleport()

func teleport() -> void:
	match GlobalVariables.town_room:
		"null":
			pass
		"subway":
			player.global_position = Vector2(3850, 2750)
			TheCamera.snap(player.global_position)
