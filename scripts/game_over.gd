extends Node
@onready var cursor: AnimatedSprite2D = $CanvasLayer/cursor
@onready var retry: TextureButton = $CanvasLayer/retry
@onready var menubutton: TextureButton = $CanvasLayer/menubutton
@onready var im_just_so_you_can_see_the_stuff: ColorRect = $"CanvasLayer/im just so you can see the stuff"
@onready var label: Label = $CanvasLayer/Label
@onready var color_rect: ColorRect = $CanvasLayer/Label/ColorRect
@onready var anim_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $CanvasLayer/AudioStreamPlayer
var newscene: String
var message: int

var focus_sfx = preload("res://audio/sfx/Hit 1.wav")
var select_sfx = preload("res://audio/sfx/Gunshot.wav")
var can_select: bool

func _ready() -> void:
	color_rect.visible = false
	can_select = false
	anim_player.play("invis")
	cursor.position.x = retry.position.x + (retry.size.x - 10)
	cursor.position.y = retry.position.y + ((retry.size.y / 2)- 5)

func process() -> void:
	retry.position.x = TheCamera.position.x
	menubutton.position.x = TheCamera.position.x
	label.position.x = TheCamera.position.x

func invis() -> void:
	color_rect.visible = false
	can_select = false
	anim_player.play("invis")

#play the animation for the death menu, and then activate menu mode
func death_menu() -> void:
	message = randi_range(1, 4)
	match message:
		1:
			label.text = "You can do better."
		2:
			label.text = "It's not over 'till you're underground."
		3:
			label.text = "The future wants to be seen."
		4:
			label.text = "You're not done yet."
	GlobalVariables.menumode = false
	anim_player.play("create_death_menu")
	await get_tree().create_timer(3).timeout
	GlobalVariables.menumode = true
	GlobalVariables.menutype = "Death"
	retry.grab_focus()
	can_select = true

#play sfx and change cursor position depending on which button is focused
func _on_retry_focus_entered() -> void:
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Death":
		cursor.position.x = retry.position.x + (retry.size.x - 10)
		cursor.position.y = retry.position.y + ((retry.size.y / 2)- 5)
		audio_player.stream = focus_sfx
		audio_player.play()

func _on_menubutton_focus_entered() -> void:
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Death":
		cursor.position.x = menubutton.position.x + (menubutton.size.x - 10)
		cursor.position.y = menubutton.position.y + ((menubutton.size.y / 2)- 5)
		audio_player.stream = focus_sfx
		audio_player.play()

func _on_retry_pressed() -> void:
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Death":
		can_select = false
	MusicController.music_fadeout_slow()
	TheCamera.screentint(0)
	audio_player.stream = select_sfx
	audio_player.play()
	anim_player.play("select_retry")
	await get_tree().create_timer(1.5).timeout
	TheCamera.transition_on()
	MusicController.music_stop()
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("Player", "respawn")
	get_tree().call_group("enemies", "respawn")
	get_tree().call_group("Objects", "respawn")
	get_tree().call_group("earthspike", "deactivate")
	get_tree().call_group("breakable_wall", "respawn")
	get_tree().call_group("Zulie", "respawn")
	get_tree().call_group("VagabondActor", "respawn")
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.menumode = false
	TheCamera.transition_off()
	invis()

func _on_menubutton_pressed() -> void:
	if can_select and GlobalVariables.menumode and GlobalVariables.menutype == "Death":
		can_select = false
	MusicController.music_fadeout_slow()
	audio_player.stream = select_sfx
	audio_player.play()
	anim_player.play("select_menu")
	await get_tree().create_timer(1.5).timeout
	TheCamera.transition_on()
	MusicController.music_fadeout_slow()
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("Player", "respawn")
	get_tree().call_group("enemies", "respawn")
	get_tree().call_group("Objects", "respawn")
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.menumode = false
	TheCamera.transition_off()
	get_tree().change_scene_to_file("res://scenes/rooms/main_menu.tscn")
	invis()
