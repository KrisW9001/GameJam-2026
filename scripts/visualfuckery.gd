extends Sprite2D

func dothething() -> void:
	region_rect.position.x = (randi_range(1,15)* 8)
	region_rect.position.y = (randi_range(1,14)* 8)
	var amiinvis = randi_range(0,3)
	if amiinvis == 3:
		visible = false
	else:
		visible = true
