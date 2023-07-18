extends Node2D

var master_bus = AudioServer.get_bus_index("Master")

func _on_perspectivetoggle_pressed():
	$effect.visible = $perspectivetoggle.pressed

func _on_perspectivetoggle_toggled(button_pressed):
	if button_pressed:
		Global.quality = 1
	else:
		Global.quality = 0
	print(Global.quality)

func _on_volumeslider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
