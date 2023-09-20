extends Node2D

func _input(_event):
	if Input.is_key_pressed(KEY_P):
		if get_tree().paused == false:
			get_tree().paused = true
		else:
			get_tree().paused = false
