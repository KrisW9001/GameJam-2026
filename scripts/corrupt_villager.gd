extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@export var speech: DialogueResource

func _ready() -> void:
	anim_sprite.play("corrupt")

func fixed() -> void:
	anim_sprite.play("normal")

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
		#check event flags for which dialogue to play when interacted with outside of a cutscene
		TalkScenes.npc_talk.dialogue_resource = speech
		body.inspect_prompt.visible = true
		body.can_talk_n = true
		print("showing inspect prompt")

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_n = false
