extends Node2D
@onready var particles: CPUParticles2D = $Particles
@onready var cutscene_lightning: CharacterBody2D = $props/CutsceneLightning
@onready var asset_noble: CharacterBody2D = $asset_noble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.noble_goto = false
	asset_noble.position = Vector2(0, -2598)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	particles.position = GlobalVariables.player_position
