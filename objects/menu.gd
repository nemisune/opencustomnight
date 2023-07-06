extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		gameLoad.load_scene(self, "res://objects/main.tscn")
