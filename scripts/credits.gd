extends Node2D
@onready var anim_player: AnimationPlayer = $visuals/AnimationPlayer
@onready var credits_anim: AnimationPlayer = $"actual credits/CreditsAnim"

func _ready() -> void:
	anim_player.play("RESET")
	GlobalVariables.cameralock = true
	GlobalVariables.lock_pos = Vector2(0,0)

#declaring animations for the character visuals
func vagabond_appear() -> void:
	anim_player.play("vagabond_appear")

func vagabond_dissapear() -> void:
	anim_player.play("vagabond_dissapear")

func marcus_appear() -> void:
	anim_player.play("marcus_appear")

func marcus_dissapear() -> void:
	anim_player.play("marcus_dissapear")

func zulie_appear() -> void:
	anim_player.play("zulie_appear")

func zulie_dissapear() -> void:
	anim_player.play("zulie_dissapear")

func show_title() -> void:
	credits_anim.play("show_title")

func _on_credits_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"show_title":
			anim_player.play("RESET")
			await get_tree().create_timer(1).timeout
			credits_anim.play("credits_scroll")
		"credits_scroll":
			credits_anim.play("show_end")
		"show_end":
			TheCamera.transition_on()
			await get_tree().create_timer(0.5).timeout
			GlobalVariables.menumode = false
			get_tree().change_scene_to_file("res://scenes/rooms/main_menu.tscn")
			MusicController.vol_reset()
			TheCamera.transition_off()
