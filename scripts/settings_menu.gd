extends Control
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var window_button: OptionButton = $CanvasLayer/WindowButton
@onready var master_vol_slider: HSlider = $CanvasLayer/MasterVolSlider
@onready var music_vol_slider: HSlider = $CanvasLayer/MusicVolSlider
@onready var sfx_vol_slider: HSlider = $CanvasLayer/SfxVolSlider
@onready var cursor: AnimatedSprite2D = $CanvasLayer/cursor
@onready var back_button: TextureButton = $CanvasLayer/BackButton

var focus_sfx = preload("res://audio/sfx/Hit 1.wav")
var select_sfx = preload("res://audio/sfx/Gunshot.wav")
var test_sfx = preload("res://audio/sfx/Sword 2.wav")

#DEV NOTE: this scene goes unused since it was just easier to make the settings menu a popup window. its not elegant, and its definitely ameteurish, but it makes my job significantly easier and doesn't interrupt immersion, so I've made the decision that it doesn't matter.

func ready() -> void:
	#GlobalVariables.menutype = "Settings"
	window_button.grab_focus()
	GlobalVariables.menumode = true

#effects for entering focus for buttons in the settings menu
func _on_window_button_focus_entered() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.position.x = window_button.position.x + (window_button.size.x + 30)
	cursor.position.y = window_button.position.y + (window_button.size.y / 2)
	audio_player.stream = focus_sfx
	audio_player.play()
	MusicController.music_stop()

func _on_master_vol_slider_focus_entered() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.position.x = master_vol_slider.position.x + (master_vol_slider.size.x + 30)
	cursor.position.y = master_vol_slider.position.y + (master_vol_slider.size.y / 2)
	audio_player.stream = focus_sfx
	audio_player.play()
	MusicController.music_stop()

func _on_music_vol_slider_focus_entered() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.position.x = music_vol_slider.position.x + (music_vol_slider.size.x + 30)
	cursor.position.y = music_vol_slider.position.y + (music_vol_slider.size.y / 2)
	audio_player.stream = focus_sfx
	audio_player.play()
	MusicController.music_stop()

func _on_sfx_vol_slider_focus_entered() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.position.x = sfx_vol_slider.position.x + (sfx_vol_slider.size.x + 30)
	cursor.position.y = sfx_vol_slider.position.y + (sfx_vol_slider.size.y / 2)
	audio_player.stream = focus_sfx
	audio_player.play()
	MusicController.music_stop()

func _on_back_button_focus_entered() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.position.x = back_button.position.x + (back_button.size.x + 20)
	cursor.position.y = back_button.position.y + (back_button.size.y / 2)
	audio_player.stream = focus_sfx
	audio_player.play()
	MusicController.music_stop()

#return to main menu when back button is pressed, return to pause menu if in pause menu instead
func _on_back_button_pressed() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#change window size after selecting something
func _on_window_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	window_button.grab_focus()
	cursor.visible = false
	master_vol_slider.editable = false
	music_vol_slider.editable = false
	sfx_vol_slider.editable = false
	back_button.disabled = true
	audio_player.stream = select_sfx
	audio_player.play()

func _on_window_button_pressed() -> void:
	#if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Settings":
	cursor.visible = true
	master_vol_slider.editable = true
	music_vol_slider.editable = true
	sfx_vol_slider.editable = true
	back_button.disabled = false
	audio_player.stream = select_sfx
	audio_player.play()

#change volume based on slider values
func _on_master_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	audio_player.stream = select_sfx
	audio_player.play()

func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	MusicController.test_music_settings()

func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	audio_player.stream = select_sfx
	audio_player.play()
