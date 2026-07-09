extends Sprite2D

#used to control the visibility of photos in the file dumps, for optimization and lag reduction
func _ready() -> void:
	modulate = Color(1,1,1,0)
	print("invisible")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	modulate = Color(1,1,1)
	print("visible")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	modulate = Color(1,1,1,0)
	print("invisible")
