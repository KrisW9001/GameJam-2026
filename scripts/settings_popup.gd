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

func _on_master_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	MusicController.test_music_stop()
	audio_player.stream = select_sfx
	audio_player.play()

func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	MusicController.test_music_settings()

func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	MusicController.test_music_stop()
	audio_player.stream = select_sfx
	audio_player.play()

#hide window when close button is pressed
func _on_close_requested() -> void:
	hide()
	MusicController.test_music_stop()
