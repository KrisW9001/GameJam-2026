extends Window

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var window_button: OptionButton = $WindowButton
@onready var master_vol_slider: HSlider = $MasterVolSlider
@onready var music_vol_slider: HSlider = $MusicVolSlider
@onready var sfx_vol_slider: HSlider = $SfxVolSlider

#defining stuff for volume sliders
var focus_sfx = preload("res://audio/sfx/Hit 1.wav")
var select_sfx = preload("res://audio/sfx/Gunshot.wav")
var test_sfx = preload("res://audio/sfx/Sword 2.wav")

func _ready() -> void:
	hide()

#add window settings eventually
func _on_master_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	SaveLoad.SaveFileData.master_volume = value
	MusicController.test_music_stop()
	audio_player.stream = select_sfx
	audio_player.play()

func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	SaveLoad.SaveFileData.music_volume = value
	MusicController.test_music_settings()

func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	SaveLoad.SaveFileData.sfx_volume = value
	MusicController.test_music_stop()
	audio_player.stream = select_sfx
	audio_player.play()

#hide window when close button is pressed
func _on_close_requested() -> void:
	SaveLoad._save()
	hide()
	MusicController.test_music_stop()

#change window settings
func _on_window_button_item_selected(index: int) -> void:
	audio_player.stream = select_sfx
	audio_player.play()
	match index:
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
