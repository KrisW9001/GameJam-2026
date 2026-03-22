extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

var whichdialogue: DialogueResource

#this scene and script are mostly for controlling an actor to be used for cutscenes and dialogue
func _ready() -> void:
	anim_sprite.visible = true
	idle_l()

func _process(delta: float) -> void:
	GlobalVariables.vagabond_position = position
	
	#move vagabond actor
	if GlobalVariables.vagabond_goto:
		position.x = move_toward(position.x, GlobalVariables.vagabond_coords.x, 300 * delta)
		position.y = move_toward(position.y, GlobalVariables.vagabond_coords.y, 300 * delta)

func coll_off() -> void:
	set_collision_layer_value(1, false)

func invis() -> void:
	anim_sprite.visible = false
	set_collision_layer_value(1, false)

func appear() -> void:
	anim_sprite.visible = true
	set_collision_layer_value(1, true)

func idle_r() -> void:
	anim_sprite.play("idle")
	anim_sprite.flip_h = true

func idle_l() -> void:
	anim_sprite.play("idle")
	anim_sprite.flip_h = false

func attack_fast_r() -> void:
	anim_sprite.play("attack_fast")
	anim_sprite.flip_h = true

func attack_fast_l() -> void:
	anim_sprite.play("attack_fast")
	anim_sprite.flip_h = false

func attack_slow_r() -> void:
	anim_sprite.play("attack_slow")
	anim_sprite.flip_h = true

func attack_slow_l() -> void:
	anim_sprite.play("attack_slow")
	anim_sprite.flip_h = false

func walk_r() -> void:
	anim_sprite.play("walk")
	anim_sprite.flip_h = true

func walk_l() -> void:
	anim_sprite.play("walk")
	anim_sprite.flip_h = false

func block_l() -> void:
	anim_sprite.play("block_l")
	anim_sprite.flip_h = false

func crouch_r() -> void:
	anim_sprite.play("crouch")
	anim_sprite.flip_h = true

func crouch_l() -> void:
	anim_sprite.play("crouch")
	anim_sprite.flip_h = false

func crouch_noweapon_l() -> void:
	anim_sprite.play("crouch_noweapon")
	anim_sprite.flip_h = false

func crouch_noweapon_r() -> void:
	anim_sprite.play("crouch_noweapon")
	anim_sprite.flip_h = true

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if anim_sprite.visible:
		if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
			#check event flags for which dialogue to play when interacted with outside of a cutscene
			if !GlobalVariables.beatfirstboss:
				TalkScenes.vagabond_talk.dialogue_resource = preload("res://dialogue/vagabond_subway.dialogue")
			if GlobalVariables.beatfirstboss and !GlobalVariables.metzulie:
				TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_subway_dismiss.dialogue")
			if GlobalVariables.metzulie and !GlobalVariables.beatsecondboss: 
				TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_pre_mage.dialogue")
			if GlobalVariables.beatsecondboss and !GlobalVariables.seennoblecut:
				TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_town.dialogue")
			if GlobalVariables.seennoblecut:
				TalkScenes.vagabond_talk.dialogue_resource = load("res://dialogue/vagabond_final_dismiss.dialogue")
			body.inspect_prompt.visible = true
			body.can_talk_v = true
			print("showing inspect prompt")

func respawn() -> void:
	if !GlobalVariables.beatsecondboss:
		GlobalVariables.vagabond_coords = Vector2(3500, 1950)
		idle_l()

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_v = false
