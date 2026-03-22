extends Camera2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var damagetint: ColorRect = $CanvasLayer/damagetint
@onready var damagetint_2: ColorRect = $CanvasLayer/damagetint2
@onready var trans_screen: ColorRect = $CanvasLayer/trans_screen
@onready var label: Label = $CanvasLayer/Label
@onready var label_2: Label = $CanvasLayer/Label2
#setting variables to be used in functions
var offscreen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.cameralock = false
	GlobalVariables.lock_pos = Vector2()
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GlobalVariables.camera_position = position
	#every frame, reduce the shake power variable of the attatched shader. this makes the glitch effect gradually decrease until it dissapears completely
	if GlobalVariables.cameralock:
		position.x = move_toward(position.x, GlobalVariables.lock_pos.x, 960 * delta)
		position.y = move_toward(position.y, GlobalVariables.lock_pos.y, 540 * delta)
	elif !GlobalVariables.cameralock:
		position.x = move_toward(position.x, GlobalVariables.player_position.x, 960 * delta)
		position.y = move_toward(position.y, GlobalVariables.player_position.y, 540 * delta)
	label_2.text = str(GlobalVariables.cur_respawn)

#reset the camera in certain situations, like when entering a new room
func reset() -> void:
	position = Vector2.ZERO

func snap(snap_pos: Vector2) -> void:
	position = snap_pos

func shake() -> void:
	anim_player.play("shake")

func dmg_shake() -> void:
	anim_player.play("dmg_shake")

#activate shaders when damaged
func screentint(amt: int) -> void:
	match amt:
		0:
			damagetint.visible = false
			damagetint_2.visible = false
		1:
			damagetint.visible = true
			damagetint_2.visible = false
		2:
			damagetint.visible = false
			damagetint_2.visible = true

#make transition visual visible/invisible
func transition_on() -> void:
	anim_player.play("trans_on")

func transition_off() -> void:
	await get_tree().create_timer(1).timeout
	anim_player.play("trans_off")

#make memory visual visible/invisible
func memory_on() -> void:
	anim_player.play("memory_on")

func memory_off() -> void:
	anim_player.play("memory_off")

func spell_flash_on() -> void:
	anim_player.play("spell_flash_on")

func spell_flash_off() -> void:
	anim_player.play("spell_flash_off")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spell_flash_on":
		CutsceneManager.cutscene9()
