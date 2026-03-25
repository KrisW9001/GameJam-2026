extends Node2D
@onready var particles: CPUParticles2D = $Particles
@onready var vagabond: CharacterBody2D = $Vagabond
@onready var zulie: CharacterBody2D = $Zulie

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if zulie:
		zulie.global_position = Vector2(66, -1910)
	if vagabond:
		vagabond.global_position = Vector2(-238, -2156)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	particles.position = GlobalVariables.player_position
