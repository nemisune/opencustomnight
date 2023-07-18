extends CanvasLayer

onready var camHUD = $camHUD
onready var camButtons = $camHUD/minimap
onready var jumpscareAnim = $jumpscare
onready var powerText = $hudElements/power
onready var scareTimer = $scaretimer
var rng = RandomNumberGenerator.new()
var on = false
var moveon = false
var alive = true
var screamType
signal monitorOn
signal monitorOff
signal go2Menu
signal sendLocation(camLoc)
signal ventSys
signal camSys
signal musicSwapped
signal itsOver
signal camShake
signal maskToggled

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_accept") && moveon == true:
		endNight()

func _on_gostatic_finished():
	endNight()

func startGame():
	Overlay.show()
	Global.power = 100
	$hudElements/am.resetLol()
	$hudElements/am/Timer.start()
	$hudElements/timer.going = true
	$monitormask/cpanel.show()
	$monitormask/mpanel.show()
	if Global.quality == 1:
		$effect.show()
	else:
		$effect.hide()

func when6AM():
	$"6am/6amplayer".play("play")

func endNight():
	$"6am/6amplayer".play("RESET")
	$gameover/gameover.play("RESET")
	$jumpscare.play("none")
	$hudElements/timer.going = false
	$hudElements/timer.time = 0
	$hudElements/am/Timer.stop()
	Overlay.hide()
	$effect.hide()
	$gameover/gostatic.stop()
	Global.povLock = false
	emit_signal("go2Menu")
	moveon = false
	alive = true
	RichPresence.update_activity()

func _process(_delta):
	if Global.power > 0:
		powerText.text = str(round(Global.power))+"%"
	else:
		powerText.text = "0%"

func jumpscareMoment(character, ver):
	RichPresence.deadAsHell()
	jumpscareAnim.play(character)
	emit_signal("camShake")
	Global.povLock = true
	screamType = ver
	get_node("scream/scream"+str(screamType)).play()
	$monitormask/cpanel.hide()
	$monitormask/mpanel.hide()
	scareTimer.start()
	if Global.mask == true:
		$monitormask.forceMaskOff()
	if Global.cam == true:
		$monitormask.forceCamOff()

func powerOff():
	$monitormask/cpanel.hide()
	$monitormask/mpanel.hide()
	if Global.mask == true:
		$monitormask.forceMaskOff()
	if Global.cam == true:
		$monitormask.forceCamOff()

func startStatic():
	$camHUD/static.staticFade()

func camOn():
	camHUD.show()
	emit_signal("monitorOn")

func camOff():
	camHUD.hide()
	emit_signal("monitorOff")

func _on_camsys_pressed():
	camButtons.show()
	emit_signal("camSys")

func _on_ventsys_pressed():
	camButtons.hide()
	emit_signal("ventSys")

func _on_scaretimer_timeout():
	$gameover/gostatic.play()
	emit_signal("itsOver")
	get_node("scream/scream"+str(screamType)).stop()
	$gameover/gameover.play("static")
	$gameover.position = $hudElements.position

func _on_camHUD_camChanged(camLoc):
	emit_signal("sendLocation",camLoc)
	if camLoc == "kitchen":
		$camHUD/changeMusic.show()
	else:
		$camHUD/changeMusic.hide()

func _on_changeMusic_pressed():
	Audio.restartMusicBox()
	emit_signal("musicSwapped")

func _on_gameover_animation_finished(_anim_name):
	moveon = true

func _on_6amplayer_animation_finished(anim_name):
	if anim_name == "play":
		endNight()

func _on_mpanel_mouse_entered():
	emit_signal("maskToggled")
