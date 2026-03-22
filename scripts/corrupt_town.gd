extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var zulie: CharacterBody2D = $Zulie
@onready var vagabond: CharacterBody2D = $Vagabond
@onready var asset_healer: CharacterBody2D = $asset_healer
@onready var breakable_walls: TileMapLayer = $BreakableWalls
@onready var key: Sprite2D = $Triggers/key

func _ready() -> void:
	if zulie:
		zulie.appear()
	if vagabond:
		vagabond.appear()
	zulie.crouch_r()
	vagabond.idle_l()
	asset_healer.idle()
	if GlobalVariables.openedpassage == true:
		breakable_walls.killwalls()
	elif GlobalVariables.openedpassage == false:
		pass
	if GlobalVariables.town_room != "null":
		town_tele()
	if GlobalVariables.haskey == true:
		key.visible = false
	elif GlobalVariables.haskey == false:
		key.visible = true
	#change zulie and vagabond's positions after obtaining the spellbook
	if GlobalVariables.hasbook == true:
		book_adjust()

func town_tele() -> void:
	match GlobalVariables.town_room:
		"Shop":
			player.global_position = Vector2(1322, -743)
			TheCamera.snap(Vector2(1322, -743))
		"Passage":
			player.global_position = Vector2(2050, -750)
			TheCamera.snap(Vector2(2050, -750))
		"storeroom_roof":
			player.global_position = Vector2(2350, -950)
			TheCamera.snap(Vector2(2350, -950))
		"Tavern":
			player.global_position = Vector2(1775, -300)
			TheCamera.snap(Vector2(1775, -300))

func book_adjust() -> void:
	zulie.global_position = Vector2(2050, -500)
	zulie.idle_r()
	vagabond.visible = false
