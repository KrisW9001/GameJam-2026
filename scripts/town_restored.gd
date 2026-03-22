extends Node2D

@onready var villager_1: CharacterBody2D = $Npcs/CorruptVillager1
@onready var villager_3: CharacterBody2D = $Npcs/CorruptVillager3
@onready var villager_2: CharacterBody2D = $Npcs/CorruptVillager2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	villager_1.fixed()
	villager_2.fixed()
	villager_3.fixed()
