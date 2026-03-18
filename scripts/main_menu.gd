extends Control
@onready var background: ColorRect = $CanvasLayer/background
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label
@onready var sprite_2d: Sprite2D = $CanvasLayer/Sprite2D
@onready var cursor: AnimatedSprite2D = $CanvasLayer/cursor
@onready var newgame_btn: TextureButton = $CanvasLayer/newgame
@onready var continue_btn: TextureButton = $CanvasLayer/continue
@onready var settings_btn: TextureButton = $CanvasLayer/settings
@onready var exit_btn: TextureButton = $CanvasLayer/exit
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var settings_popup: Window = $SettingsPopup

var focus_sfx = preload("res://audio/sfx/Hit 1.wav")
var select_sfx = preload("res://audio/sfx/Gunshot.wav")
var can_select: bool = false

#DEV NOTE: I now despise coding menus from scratch. It's for the best that I did it, but i still hate it.

#upon starting the game, run the function to draw the main menu
func _ready() -> void:
	GlobalVariables.menutype = "Main"
	create()
	if !GlobalVariables.cont_scene == "null":
		continue_btn.modulate = Color(1.0, 1.0, 1.0)
	else:
		continue_btn.modulate = Color(1.0, 1.0, 1.0, 0.5)

func invis() -> void:
	anim_player.play("invis")

func create() -> void:
	canvas_layer.visible = true
	anim_player.play("create")
	GlobalVariables.menutype = "Main"
	GlobalVariables.menumode = true
	newgame_btn.grab_focus()
	cursor.position.x = newgame_btn.position.x + (newgame_btn.size.x + 20)
	cursor.position.y = newgame_btn.position.y + ((newgame_btn.size.y / 2))
	can_select = true

#play sfx and change cursor position depending on which button is focused
func _on_newgame_focus_entered() -> void:
	cursor.position.x = newgame_btn.position.x + (newgame_btn.size.x + 20)
	cursor.position.y = newgame_btn.position.y + ((newgame_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

func _on_continue_focus_entered() -> void:
	cursor.position.x = continue_btn.position.x + (continue_btn.size.x + 20)
	cursor.position.y = continue_btn.position.y + ((continue_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

func _on_settings_focus_entered() -> void:
	cursor.position.x = settings_btn.position.x + (settings_btn.size.x + 20)
	cursor.position.y = settings_btn.position.y + ((settings_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

func _on_exit_focus_entered() -> void:
	cursor.position.x = exit_btn.position.x + (exit_btn.size.x + 20)
	cursor.position.y = exit_btn.position.y + ((exit_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

#on starting a new game, clear any event flags and start the player at the beginning
func _on_newgame_pressed() -> void:
	SaveLoad.clear_save()
	SaveLoad._save()
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Main":
		OS.alert("This Godot Project has been abandoned.

Some aspects of the game may not function as intended, or at all.

Please be aware that any inconsistencies or errors in gameplay or scripting is the result of ameteur coding and is not fully representative of The Creator's vision.

Player discretion is advised.", "Game Quality Warning")
	audio_player.stream = select_sfx
	audio_player.play()
	GlobalVariables.menumode = false
	TheCamera.transition_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/rooms/test_map.tscn")
	PauseMenu.invis()
	TheCamera.transition_off()

func _on_continue_pressed() -> void:
	if !GlobalVariables.cont_scene == "null":
		SaveLoad._load()
		audio_player.stream = select_sfx
		audio_player.play()
		GlobalVariables.menumode = false
		TheCamera.transition_on()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file(GlobalVariables.cont_scene)
		PauseMenu.invis()
		TheCamera.transition_off()

func _on_settings_pressed() -> void:
	SettingsPopup.show()

func _on_exit_pressed() -> void:
	TheCamera.transition_on()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
