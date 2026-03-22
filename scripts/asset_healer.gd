extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var displacer: AnimationPlayer = $displacer

var die_sfx = load("res://audio/sfx/Explosion.wav")
var speed: int = 250
var whichdialogue: DialogueResource
var punching: bool = false

func _process(delta: float) -> void:
	#GlobalVariables.mage_position = position
	
	if GlobalVariables.healer_goto:
		position.x = move_toward(position.x, GlobalVariables.healer_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.healer_coords.y, (speed / 2) * delta)
	
	if position.x < GlobalVariables.player_position.x:
		anim_sprite.flip_h = false
	elif position.x > GlobalVariables.player_position.x:
		anim_sprite.flip_h = true
	
	if position == GlobalVariables.healer_coords and !punching:
		anim_sprite.play("idle")

#declaring animations
func idle() -> void:
	anim_sprite.play("idle")

func walk() -> void:
	anim_sprite.play("walk")

func flinch() -> void:
	anim_sprite.play("flinch")

func punch() -> void:
	punching = true
	anim_sprite.play("punch")

func die() -> void:
	displacer.play("yeet")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_away":
		TalkScenes.protag_talk.dialogue_resource = load("res://dialogue/healer_defeated.dialogue")
		TalkScenes.protag_talk.start()
		queue_free()

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and !GlobalVariables.cutscenemode:
		#check event flags for which dialogue to play when interacted with outside of a cutscene
		TalkScenes.healer_talk.dialogue_resource = load("res://dialogue/healer_intro.dialogue")
		body.inspect_prompt.visible = true
		body.can_talk_h = true
		print("showing inspect prompt")

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		body.inspect_prompt.visible = false
		body.can_talk_h = false

func _on_displacer_animation_finished(anim_name: StringName) -> void:
	anim_sprite.z_index = 2
	anim_sprite.play("die")
	audio_player.stream = die_sfx
	audio_player.play()
	anim_sprite.speed_scale = 0.1
	anim_player.play("fade_away")
	CutsceneManager.boss_kill()
