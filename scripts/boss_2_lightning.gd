extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var charge: Timer = $charge
@onready var area_2d: Area2D = $Area2D
@export var damage: int
var active: bool
var striking: bool = false
var dealtdamage: bool
var charge_sfx = load("res://audio/sfx/Misc_SpringySweep.wav")
var strike_sfx = load("res://audio/sfx/EnergyBlastRise.ogg")

#controls lightning attacks during mage boss
func _ready() -> void:
	active = false
	dealtdamage = true
	area_2d.set_collision_mask_value(2, false)

func activate() -> void:
	active = true
	anim_sprite.visible = true
	charging()

func deactivate() -> void:
	active = false
	charge.stop()
	area_2d.set_collision_mask_value(2, false)
	audio_player.stop()
	anim_sprite.visible = false

func charging() -> void:
	if active:
		var pos_change_x = randi_range(-250, 250)
		var pos_change_y = randi_range(-250, 250)
		position.x = GlobalVariables.player_position.x + pos_change_x
		position.y = GlobalVariables.player_position.y + pos_change_y
		area_2d.set_collision_mask_value(2, false)
		anim_sprite.play("charge")
		dealtdamage = false
		audio_player.stream = charge_sfx
		audio_player.play()
		charge.start()
	
#if charging animation finishes but charge is not finished, replay the charge animation
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite.animation == "strike":
		charging()

func _on_charge_timeout() -> void:
	if active:
		anim_sprite.play("strike")
		audio_player.stream = strike_sfx
		audio_player.play()
		striking = true
		area_2d.set_collision_mask_value(2, true)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and body.dead == false and !dealtdamage:
		print("you took damage from a spell")
		body.hurt_player(damage, position.x, position.y)
		dealtdamage = true
