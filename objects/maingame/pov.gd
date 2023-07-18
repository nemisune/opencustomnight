extends Camera2D

func _process(_delta):
	if Global.povLock == false:
		position.x += (get_global_mouse_position().x - position.x)/25

