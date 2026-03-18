extends Node2D
@onready var zulie: CharacterBody2D = $Zulie
@onready var vagabond: CharacterBody2D = $Vagabond
@onready var asset_healer: CharacterBody2D = $asset_healer

func _ready() -> void:
	if zulie:
		zulie.appear()
	if vagabond:
		vagabond.appear()
	zulie.crouch_r()
	vagabond.idle_l()
	asset_healer.idle()
