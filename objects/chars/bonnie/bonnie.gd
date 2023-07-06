extends Node2D

onready var sprite = $camerasprite
var active = false

func _on_detectCamera_area_entered(area):
	if active == true:
		sprite.play("default")
		Audio.playScream()

func _on_detectCamera_area_exited(area):
	pass # Replace with function body.

func _on_camerasprite_animation_finished():
	VFX.scrambleCams()
