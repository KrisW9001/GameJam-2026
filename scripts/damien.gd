extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

var speed: int = 200

func _ready() -> void:
	idle_up()

func _process(delta: float) -> void:
	#GlobalVariables.damien_position = position
	
	#move zulie actor
	if GlobalVariables.damien_goto:
		position.x = move_toward(position.x, GlobalVariables.damien_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.damien_coords.y, speed * delta)

#defining animations
func idle_up() -> void:
	anim_sprite.play("idle_up")

func idle_left() -> void:
	anim_sprite.play("idle_left")

func idle_right() -> void:
	anim_sprite.play("idle_right")

func idle_down() -> void:
	anim_sprite.play("idle_down")

func walk_up() -> void:
	anim_sprite.play("walk_up")

func walk_down() -> void:
	anim_sprite.play("walk_down")

func walk_left() -> void:
	anim_sprite.play("walk_left")

func walk_right() -> void:
	anim_sprite.play("walk_right")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
			#check event flags for which dialogue to play when interacted with outside of a cutscene
			if GlobalVariables.metdamien == false:
				TalkScenes.damien_talk.dialogue_resource = load("res://dialogue/damien_intro.dialogue")
			elif GlobalVariables.metdamien == true:
				TalkScenes.damien_talk.dialogue_resource = load("res://dialogue/damien_dismiss.dialogue")
			body.inspect_prompt.visible = true
			body.can_talk_d = true
			print("showing inspect prompt")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_d = false
