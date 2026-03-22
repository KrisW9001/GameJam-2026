extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var glitch_effect: ColorRect = $glitch_effect
@onready var warp_player: AnimationPlayer = $warp
@onready var damage: AnimationPlayer = $damage

const speed: int = 300
var health: int = 10
var in_fight: bool = false

var dmg_sfx = load("res://audio/sfx/Door Close Big.wav")
var warp_sfx = load("res://audio/sfx/Misc_GlitchNoisy1.wav")

func _ready() -> void:
	idle_r()
	in_fight = true

func _process(delta: float) -> void:
	if GlobalVariables.noble_goto == true:
		position.x = move_toward(position.x, GlobalVariables.noble_coords.x, speed * delta)
		position.y = move_toward(position.y, GlobalVariables.noble_coords.y, (speed / 2) * delta)
		if position == GlobalVariables.noble_coords and CutsceneManager.incut10 == true:
			idle_l()

#declaring animations
func idle_l() -> void:
	anim_sprite.play("idle_l")

func idle_r() -> void:
	anim_sprite.play("idle_r")

func walk_l() -> void:
	anim_sprite.play("walk_l")

func walk_r() -> void:
	anim_sprite.play("walk_r")

func shoot_l() -> void:
	anim_sprite.play("shoot_l")

func shoot_r() -> void:
	anim_sprite.play("shoot_r")

func point_l() -> void:
	anim_sprite.play("point_l")

func point_r() -> void:
	anim_sprite.play("point_r")

func jump_l() -> void:
	anim_sprite.play("jump_l")

func jump_r() -> void:
	anim_sprite.play("jump_r")

func weak_l() -> void:
	anim_sprite.play("weak_l")

func weak_r() -> void:
	anim_sprite.play("weak_r")

func warp() -> void:
	position = GlobalVariables.noble_coords
	audio_player.stream = warp_sfx
	audio_player.play()
	warp_player.play("glitch_warp")

func cutscene_damage() -> void:
	damage.play("damage_flash")
	audio_player.stream = dmg_sfx
	audio_player.play()

#func fight_start() -> void:
	#in_fight = true
#
#func fight_end() -> void:
	#in_fight = false
