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
		pass

func coll_off() -> void:
	set_collision_layer_value(1, false)

func invis() -> void:
	anim_sprite.visible = false
	set_collision_layer_value(1, false)

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

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if anim_sprite.visible:
		if body.is_in_group("Player"):
			#check event flags for which dialogue to play when interacted with outside of a cutscene
			if !GlobalVariables.beatfirstboss:
				TalkScenes.vagabond_talk.dialogue_resource = preload("res://dialogue/vagabond_subway.dialogue")
			body.inspect_prompt.visible = true
			body.can_talk_v = true
			print("showing inspect prompt")

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_v = false
