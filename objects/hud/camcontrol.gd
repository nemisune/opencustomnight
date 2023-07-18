extends Node2D

signal camChanged(camLoc)

func _on_cam02_pressed():
	$blip.play()
	emit_signal("camChanged", "rhall")
func _on_cam01_pressed():
	$blip.play()
	emit_signal("camChanged", "lhall")
func _on_cam03_pressed():
	$blip.play()
	emit_signal("camChanged", "closet")
func _on_cam04_pressed():
	$blip.play()
	$changeMusic.show()
	emit_signal("camChanged", "kitchen")
func _on_cam05_pressed():
	$blip.play()
	emit_signal("camChanged", "cove")
func _on_cam06_pressed():
	$blip.play()
	emit_signal("camChanged", "fcove")
func _on_cam07_pressed():
	$blip.play()
	emit_signal("camChanged", "counter")
func _on_cam08_pressed():
	$blip.play()
	emit_signal("camChanged", "gamer")

func _on_cbutton_mouse_entered():
	pass
