extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var emote: AnimatedSprite2D = $emote

#this node is a stand-in for the player during cutscenes.
func ready() -> void:
	anim_sprite.visible = false
	emote.visible = false

func iliketospin() -> void:
	anim_sprite.play("spin")

func emote_exclaim() -> void:
	emote.visible = true
	emote.play("exclamation")
	await get_tree().create_timer(0.5).timeout
	emote.visible = false

#stop moving instantly.
func stop_moving() -> void:
	velocity = Vector2.ZERO
