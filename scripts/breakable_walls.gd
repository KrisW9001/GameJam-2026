extends TileMapLayer

@export var whichwall: int
@export var cur_hp: int

func ready() -> void:
	cur_hp = 3

func damage(damage: int) -> void:
	cur_hp = cur_hp - damage
	print(cur_hp)
	if cur_hp == 0:
		killwalls()

func killwalls() -> void:
	queue_free()
