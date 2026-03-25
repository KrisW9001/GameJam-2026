extends Node2D
@onready var vagabond: CharacterBody2D = $Vagabond

@onready var axe: CharacterBody2D = $Axe

func _ready() -> void:
	vagabond.invis()
	GlobalVariables.haspass = false
