extends Camera2D

var pos

func _process(delta):
	position.x += (get_global_mouse_position().x - position.x)/25
