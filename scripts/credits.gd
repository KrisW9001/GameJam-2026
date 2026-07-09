extends Node2D
@onready var marcus_anim: AnimationPlayer = $visuals/marcus_anim
@onready var vagabond_anim: AnimationPlayer = $visuals/vagabond_anim
@onready var zulie_anim: AnimationPlayer = $visuals/zulie_anim
@onready var credits_anim: AnimationPlayer = $"actual credits/CreditsAnim"
@onready var timer: Timer = $Timer

func _ready() -> void:
	marcus_anim.play("RESET")
	vagabond_anim.play("RESET")
	zulie_anim.play("RESET")
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(0,0)

#declaring animations for the character visuals
func vagabond_appear() -> void:
	vagabond_anim.play("appear")

func vagabond_disappear() -> void:
	vagabond_anim.play("disappear")

func marcus_appear() -> void:
	marcus_anim.play("appear")

func marcus_disappear() -> void:
	marcus_anim.play("disappear")

func zulie_appear() -> void:
	zulie_anim.play("appear")

func zulie_disappear() -> void:
	zulie_anim.play("disappear")

func show_title() -> void:
	credits_anim.play("show_title")

func _on_credits_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"show_title":
			marcus_anim.play("RESET")
			#await get_tree().create_timer(1).timeout
			timer.start(1)
			await timer.timeout
			credits_anim.play("credits_scroll")
		"credits_scroll":
			credits_anim.play("show_end")
		"show_end":
			GlobalVariables.finishedgame = true
			TheCamera.transition_on()
			#await get_tree().create_timer(0.5).timeout
			timer.start(0.5)
			await timer.timeout
			GlobalVariables.menumode = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			MusicController.vol_reset()
			TheCamera.transition_off()
