extends TileMapLayer

@export var whichwall: int
@export var cur_hp: int
@export var respawn_coords: Vector2

func ready() -> void:
	cur_hp = 3

func damage(damage: int) -> void:
	cur_hp = cur_hp - damage
	print(cur_hp)
	if cur_hp == 0:
		killwalls()

func killwalls() -> void:
	position.x -= 50000
	position.y -= 50000

func respawn() -> void:
	position.x = respawn_coords.x
	position.y = respawn_coords.y
	cur_hp = 3
