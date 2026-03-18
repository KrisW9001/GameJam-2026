extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_sword: CharacterBody2D = $"../../effects/cutscene_sword_spell"

var die_sfx = preload("res://audio/sfx/Explosion.wav")
var tele_in_sfx = load("res://audio/sfx/Menu Close.wav")
var tele_out_sfx = load("res://audio/sfx/Menu Cancel.wav")
var speed: int = 400

func _process(delta: float) -> void:
	GlobalVariables.mage_position = position
	
	if GlobalVariables.mage_goto:
		position.x = move_toward(position.x, GlobalVariables.mage_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.mage_coords.y, (speed / 2) * delta)

#declaring animations
func idle_l() -> void:
	anim_sprite.play("idle_l")

func idle_r() -> void:
	anim_sprite.play("idle_r")

func shoot_l() -> void:
	anim_sprite.play("shoot_l")

func shoot_r() -> void:
	anim_sprite.play("shoot_r")

func walk_l() -> void:
	anim_sprite.play("walk_l")

func walk_r() -> void:
	anim_sprite.play("walk_r")

func scared_l() -> void:
	anim_sprite.play("scared_l")

func scared_r() -> void:
	anim_sprite.play("scared_r")

func tele_in() -> void:
	animation_player.play("teleport_in")
	audio_player.stream = tele_in_sfx
	audio_player.play()

func tele_out() -> void:
	animation_player.play("teleport_out")
	audio_player.stream = tele_out_sfx
	audio_player.play()

func aim_l() -> void:
	anim_sprite.play("aim_l")

func tele_sound() -> void:
	audio_player.stream = tele_in_sfx
	audio_player.play()

func invis() -> void:
	animation_player.play("invis")

func visible() -> void:
	animation_player.play("RESET")

#interactions with cutscene sword
func sword_spawn() -> void:
	cutscene_sword.activate()

func sword_shoot_1() -> void:
	cutscene_sword.shoot(8050, 1900)

func sword_shoot_2() -> void:
	cutscene_sword.shoot(8750, 1890)

func sword_spin() -> void:
	cutscene_sword.spin(8000, 1860)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("sword"):
		if body.active:
			body.hit_mage()
			hurt_boss(1)

func hurt_boss(damage: int) -> void:
	anim_sprite.play("die")
	audio_player.stream = die_sfx
	audio_player.play()
	anim_sprite.speed_scale = 0.1
	animation_player.play("fade_away")
	CutsceneManager.boss_kill()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_away":
		Engine.set("time_scale", 1)
		CutsceneManager.cutscene7_part3()
		queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	anim_sprite.pause()
