extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	if GlobalVariables.hasbook == true:
		visible = false
