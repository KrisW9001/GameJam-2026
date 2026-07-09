extends Node2D
@onready var file: Sprite2D = $file
@onready var glitch: Sprite2D = $glitch
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	animation_player.play("colorshift")

func _on_timer_timeout() -> void:
	#glitch.region_rect.position.x = (randi_range(1,15)* 8)
	#glitch.region_rect.position.y = (randi_range(1,14)* 8)
	get_tree().call_group("visualfuckery", "dothething")
	file.region_rect.position.x = randi_range(5,-5)
	file.region_rect.position.y = randi_range(5,-5)
	file.z_index = randi_range(1, 2)

func destroy() -> void:
	animation_player.play("destroy")
