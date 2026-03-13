extends Area2D

@export var whodoibreak: int
@onready var breakable_walls: TileMapLayer = $"../../BreakableWalls"
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var is_playing: bool = false

#declaring what songs are
var damage_sfx = preload("res://audio/sfx/Explosion Sharp.wav")

#when an object is thrown into this area, reduce the health of the breakable wall
func _on_body_entered(_body: CharacterBody2D) -> void:
	if _body.is_in_group("Objects") and _body.get_child(2).flying:
		breakable_walls.damage(_body.throw_damage)
		print("the starting walls have been hit")
		particles.emitting = true
		TheCamera.shake()
		audio_player.stream = damage_sfx
		audio_player.play()
		await get_tree().create_timer(1.06).timeout
		audio_player.volume_db += 10
