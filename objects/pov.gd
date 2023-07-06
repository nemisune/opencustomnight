extends Camera2D

var lock = false

func _process(_delta):
	if lock == false:
		position.x += (get_global_mouse_position().x - position.x)/25
	else:
		pass
