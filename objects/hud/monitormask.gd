extends Control

onready var camAnim = $cameraAnim
onready var headbob = $mask/maskanimation
onready var breathing = $mask/breathing
onready var maskOn = $mask/maskon
onready var maskOff = $mask/maskoff
onready var camUp = $monitor/camup
onready var camDown = $monitor/camdown

func _on_cpanel_mouse_entered():
	Global.cam = !Global.cam
	if Global.cam == true:
		Global.povLock = true
		camUp.play()
		camAnim.play("camUp")
	else:
		Global.povLock = false
		camUp.stop()
		camDown.play()
		camAnim.play("camDown")

func _on_mpanel_mouse_entered():
	Global.mask = !Global.mask
	if Global.mask == true:
		maskOn.play()
		camAnim.play("maskDown")
		headbob.play("breathing")
		breathing.play()
	else:
		maskOff.play()
		camAnim.play("maskUp")
		headbob.play("RESET")

func forceMaskOff():
	Global.mask = false
	maskOff.play()
	camAnim.play("maskUp")
	headbob.play("RESET")

func forceCamOff():
	Global.cam = false
	camUp.stop()
	camDown.play()
	camAnim.play("camDown")
