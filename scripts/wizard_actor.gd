extends AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("invis")

func tele_in() -> void:
	animation_player.play("tele_in")

func respawn() -> void:
	animation_player.play("invis")
