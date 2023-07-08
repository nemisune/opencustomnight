extends CanvasLayer

onready var tablet = $monitor
onready var camHUD = $camHUD
onready var camButtons = $camHUD/minimap
onready var jumpscare = $jumpscare
onready var mask = $mask
onready var powerText = $hudElements/power
onready var camUpSound = $camup
onready var camDownSound = $camdown
onready var maskPanel = $panels/mbutton
onready var camPanel = $panels/cbutton
onready var scareTimer = $scaretimer
var rng = RandomNumberGenerator.new()
var on = false
signal monitorOn
signal monitorOff
signal go2Menu
signal sendLocation(camLoc)
signal ventSys
signal camSys
signal musicSwapped

func _ready():
	if get_parent().get_name() == "main":
		connect("monitorOn", get_parent(), "turnMonitorOn")
		connect("monitorOff", get_parent(), "turnMonitorOff")
		connect("sendLocation", get_parent(), "changeCam")
		connect("ventSys", get_parent(), "ventToggle")
		connect("camSys", get_parent(), "camToggle")
		connect("musicSwapped", get_parent(), "musicChanged")
		connect("go2Menu", get_parent(), "goToMenu")

func _process(_delta):
	powerText.text = str(round(Global.power))+"%"

func mouseEntered():
	maskPanel.visible = !maskPanel.visible
	if Global.cam == false:
		tablet.play("on")
		camUpSound.play()
	else:
		VFX.clearCamFX()
		camUpSound.stop()
		camDownSound.play()
		tablet.play("off")

func _on_monitor_frame_changed():
	var wow = tablet.get_animation()
	if wow == "on":
		if tablet.frame == 9:
			Global.cam = true
			emit_signal("monitorOn")
			VFX.playStatic()
			camHUD.show()
	else:
		if tablet.frame == 0:
			camHUD.hide()
			Global.cam = false
			emit_signal("monitorOff")

func _on_mbutton_mouse_entered():
	mask.play("on", (Global.mask))
	Global.mask = !Global.mask
	camPanel.visible = !camPanel.visible
	if Global.mask == true:
		$maskon.play()
	else:
		$mask/maskanimation.play("RESET")
		$mask/breathing.stop()
		$maskoff.play()

func _on_mask_animation_finished():
	if Global.mask == true:
		$mask/breathing.play()
		$mask/maskanimation.play("breathing")

func jumpscare():
	if Global.jumpscare != "none":
		jumpscare.play(str(Global.jumpscare))
		scareTimer.start()
	if Global.jumpscareNow != "none":
		jumpscare.play(str(Global.jumpscareNow))
		scareTimer.start()

func _on_camsys_pressed():
	camButtons.show()
	emit_signal("camSys")

func _on_ventsys_pressed():
	camButtons.hide()
	emit_signal("ventSys")

func _on_scaretimer_timeout():
	emit_signal("go2Menu")
	Audio.stopScream()

func _on_camHUD_camChanged(camLoc):
	emit_signal("sendLocation",camLoc)
	VFX.playStatic()

func _on_changeMusic_pressed():
	Audio.restartMusicBox()
	emit_signal("musicSwapped")

