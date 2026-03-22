extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var whichdialogue: DialogueResource
var opengate_sfx = load("res://audio/sfx/Coin 6.wav")
var slash_sfx = load("res://audio/sfx/Sword 2.wav")
#this scene and script are mainly for controlling this character during cutscenes
func _ready() -> void:
	idle_l()

func _process(delta: float) -> void:
	GlobalVariables.zulie_position = position
	
	#move zulie actor
	if GlobalVariables.zulie_goto:
		position.x = move_toward(position.x, GlobalVariables.zulie_coords.x, 600 * delta)
		position.y = move_toward(position.y, GlobalVariables.zulie_coords.y, 600 * delta)

func invis() -> void:
	anim_sprite.visible = false
	set_collision_layer_value(1, false)

func appear() -> void:
	anim_sprite.visible = true
	set_collision_layer_value(1, true)

func idle_l() -> void:
	anim_sprite.play("idle_l")
 
func idle_r() -> void:
	anim_sprite.play("idle_r")

func walk_l() -> void:
	anim_sprite.play("walk_l")

func walk_r() -> void:
	anim_sprite.play("walk_r")

func dash_l() -> void:
	anim_sprite.play("dash_l")

func dash_r() -> void:
	anim_sprite.play("dash_r")

func slash_l() -> void:
	anim_sprite.play("slash_l")
	audio_stream_player.stream = slash_sfx
	audio_stream_player.play()

func slash_r() -> void:
	anim_sprite.play("slash_r")
	audio_stream_player.stream = slash_sfx
	audio_stream_player.play()

func cslash_l() -> void:
	anim_sprite.play("cslash_l")
	audio_stream_player.stream = slash_sfx
	audio_stream_player.play()

func cslash_r() -> void:
	anim_sprite.play("cslash_r")
	audio_stream_player.stream = slash_sfx
	audio_stream_player.play()

func crouch_l() -> void:
	anim_sprite.play("crouch_l")

func crouch_r() -> void:
	anim_sprite.play("crouch_r")

func divekick_l() -> void:
	anim_sprite.play("divekick_l")

func divekick_r() -> void:
	anim_sprite.play("divekick_r")

func land_l() -> void:
	anim_sprite.play("land_l")

func land_r() -> void:
	anim_sprite.play("land_r")

func jump_up_l() -> void:
	anim_sprite.play("jump_up_l")

func jump_up_r() -> void:
	anim_sprite.play("jump_up_r")

func jump_down_l() -> void:
	anim_sprite.play("jump_down_l")

func jump_down_r() -> void:
	anim_sprite.play("jump_down_r")

func stance_l() -> void:
	anim_sprite.play("stance_l")

func stance_r() -> void:
	anim_sprite.play("stance_r")

func upright_l() -> void:
	anim_sprite.play("upright_l")

func upright_r() -> void:
	anim_sprite.play("upright_r")

func open_gate() -> void:
	audio_stream_player.stream = opengate_sfx
	audio_stream_player.play()

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if anim_sprite.visible:
		if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
			#check event flags for which dialogue to play when interacted with outside of a cutscene
			if GlobalVariables.metzulie and !GlobalVariables.beatsecondboss:
				TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_pre_mage.dialogue")
			if GlobalVariables.beatsecondboss and !GlobalVariables.hasbook:
				TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_town.dialogue")
			if GlobalVariables.hasbook and !GlobalVariables.seennoblecut:
				TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_post_book.dialogue")
			if GlobalVariables.seennoblecut:
				TalkScenes.zulie_talk.dialogue_resource = load("res://dialogue/zulie_final_dismiss.dialogue")
			body.inspect_prompt.visible = true
			body.can_talk_z = true
			print("showing inspect prompt")

func respawn() -> void:
	if !GlobalVariables.beatsecondboss:
		position = Vector2(3500, 2200)
		GlobalVariables.zulie_coords = Vector2(3500, 2200)
		upright_l()

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_z = false
