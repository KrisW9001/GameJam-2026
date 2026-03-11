extends Node

func respawn() -> void:
	print("spawning at cur_coords")
	GlobalVariables.player_position.x = GlobalVariables.cur_coords.x
	GlobalVariables.player_position.y = GlobalVariables.cur_coords.y
