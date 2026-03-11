extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var background: ColorRect = $CanvasLayer/ColorRect
@onready var label: Label = $CanvasLayer/Label
@onready var continue_btn: Button = $CanvasLayer/continue_btn
@onready var continue_background: ColorRect = $CanvasLayer/continue_btn/ColorRect
@onready var menu_btn: TextureButton = $CanvasLayer/menu_btn
@onready var settings_btn: TextureButton = $CanvasLayer/settings_btn
@onready var cursor: AnimatedSprite2D = $CanvasLayer/cursor
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var focus_sfx = preload("res://audio/sfx/Hit 1.wav")
var select_sfx = preload("res://audio/sfx/Gunshot.wav")
var can_select: bool = false
var pause_cooldown: bool = true
var cur_select: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invis()
	#create()

func invis() -> void:
	get_tree().paused = false
	anim_player.play("invis")
	canvas_layer.visible = false
	pause_cooldown = true
	GlobalVariables.menumode = false

func create() -> void:
	print("creating pause menu")
	anim_player.play("create")
	canvas_layer.visible = true
	cursor.visible = false
	GlobalVariables.menumode = true
	GlobalVariables.menutype = "Pause"
	continue_btn.grab_focus()
	cur_select = -1
	cursor.position.x = continue_btn.position.x + (continue_btn.size.x + 30)
	cursor.position.y = continue_btn.position.y + ((continue_btn.size.y / 2))
	get_tree().paused = true
	await get_tree().create_timer(.5).timeout
	pause_cooldown = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and GlobalVariables.menumode and GlobalVariables.menutype == "Pause":
		if !pause_cooldown:
			audio_player.stream = select_sfx
			audio_player.play()
			invis()
		else:
			pass
	
	#manually coding menu interactions due to how get_tree().paused works
	if Input.is_action_just_pressed("down_input") and GlobalVariables.menumode and GlobalVariables.menutype == "Pause":
		cursor.visible = true
		match cur_select:
			-1:
				continue_btn.grab_focus()
				cur_select += 1
				
			0:
				settings_btn.grab_focus()
				cur_select += 1
			1:
				menu_btn.grab_focus()
				cur_select += 1
			2:
				menu_btn.grab_focus()
	if Input.is_action_just_pressed("up_input") and GlobalVariables.menumode and GlobalVariables.menutype == "Pause":
		cursor.visible = true
		match cur_select:
			-1:
				continue_btn.grab_focus()
				cur_select += 1
			0:
				continue_btn.grab_focus()
			1:
				continue_btn.grab_focus()
				cur_select -= 1
			2:
				settings_btn.grab_focus()
				cur_select -= 1
	if Input.is_action_just_pressed("attack") and GlobalVariables.menumode and GlobalVariables.menutype == "Pause":
		match cur_select:
			0:
				continue_btn.button_pressed = true
			1:
				settings_btn.button_pressed = true
			2:
				menu_btn.button_pressed = true

#play sfx and move cursor when focus changes
func _on_continue_btn_focus_entered() -> void:
	cursor.position.x = continue_btn.position.x + (continue_btn.size.x + 30)
	cursor.position.y = continue_btn.position.y + ((continue_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

func _on_settings_btn_focus_entered() -> void:
	cursor.position.x = settings_btn.position.x + (settings_btn.size.x + 30)
	cursor.position.y = settings_btn.position.y + ((settings_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

func _on_menu_btn_focus_entered() -> void:
	cursor.position.x = menu_btn.position.x + (menu_btn.size.x + 30)
	cursor.position.y = menu_btn.position.y + ((menu_btn.size.y / 2))
	audio_player.stream = focus_sfx
	audio_player.play()

#return to the main menu
func _on_menu_btn_pressed() -> void:
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Pause":
		can_select = false
	audio_player.stream = select_sfx
	audio_player.play()
	TheCamera.transition_on()
	MusicController.music_fadeout_slow()
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("Player", "respawn")
	get_tree().call_group("enemies", "respawn")
	get_tree().call_group("Objects", "respawn")
	GlobalVariables.menumode = false
	TheCamera.transition_off()
	invis()
	get_tree().change_scene_to_file("res://scenes/rooms/main_menu.tscn")

#create settings popup
func _on_settings_btn_pressed() -> void:
	SettingsPopup.show()

#return to normal gameplay
func _on_continue_btn_pressed() -> void:
	invis()
