extends Label
var penis: bool = false
var x: int 
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invis()

func invis() -> void:
	anim_player.play("RESET")
	penis = false

func visible() -> void:
	anim_player.play("visible")
	penis = true
