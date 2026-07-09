extends Node2D
@onready var artifact: Node2D = $triggers/Artifact
@onready var animglitch: TileMapLayer = $visuals/animglitch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.artifact1 == false:
		artifact.visible = true
		animglitch.visible = true
	elif GlobalVariables.artifact1 == true:
		artifact.visible = false
		animglitch.visible = false
	MusicController.music_stop()

func glitch_begone() -> void:
	animglitch.visible = false
