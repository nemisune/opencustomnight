extends Node2D

onready var officePov = $pov
onready var camPov = $campov
onready var tweenShake = $pov/shakeTween
onready var freq = $pov/freq
onready var dur = $pov/duration
onready var camMovement = $campov/camMover
onready var ventPov = $ventpov
onready var camHitbox = $campov/camHitbox/camHitshape
onready var kitchenSounds = get_node("/root/Audio/kitchensounds")
var rng = RandomNumberGenerator.new()
var paused = false
var powerCounter
var cadet
var animatronic
var puppetPhase = 0
var lastLoc = "lhall"
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
var amplitude = 0

func _ready():
	Global.mode = "game"
	Audio.playBGM()
	Overlay.startGame()
	RichPresence.startNight()
	connectSignals()
	camMovement.play("yeah")
	powerCounter = Overlay.get_node("hudElements/power")
	kitchenSounds.position = $cameras/kitchen.position
	Audio.playMusicBox()
	for animatronic in ["cadet","freddy", "chica", "foxy", "bb", "jj", "toybonnie", "toychica", "scrap", "fredbear", "nightfreddy", "goldy"]:
		load_char(animatronic)

func _input(_event):
	if Input.is_action_pressed("flashlight") && Global.disableFlash == false:
		Global.flash = true
		$pov/flash.show()
	else:
		Global.flash = false
		$pov/flash.hide()
	if Input.is_key_pressed(KEY_BACKSLASH):
		Overlay.when6AM()
		delEverything()
		print("cheater!")

func connectSignals():
	Overlay.connect("monitorOn", self, "turnMonitorOn")
	Overlay.connect("monitorOff", self, "turnMonitorOff")
	Overlay.connect("sendLocation", self, "changeCam")
	Overlay.connect("ventSys", self, "ventToggle")
	Overlay.connect("camSys", self, "camToggle")
	Overlay.connect("go2Menu", self, "goToMenu")
	Overlay.connect("itsOver", self, "delEverything")
	Overlay.connect("camShake", self, "startShake")

func load_char(animatronic):
	var string_var :String = animatronic
	if Global.AI[string_var] > 0:
		animatronic = load(str("res://objects/chars/",animatronic,"/",animatronic,".tscn")).instance()
		add_child(animatronic)
		animatronic.add_to_group("animatronics")

func unloadChar():
	for threats in get_tree().get_nodes_in_group("animatronics"):
		threats.queue_free()

func startShake(duration = 2, frequency = 20, amplitude = 27):
	$office.playShake()
	self.amplitude = amplitude
	dur.wait_time = duration
	freq.wait_time = 1/float(frequency)
	dur.start()
	freq.start()
	createShake()

func createShake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	tweenShake.interpolate_property(officePov, "offset", officePov.offset, rand, freq.wait_time, TRANS, EASE)
	tweenShake.start()

func reset():
	tweenShake.interpolate_property(officePov, "offset", officePov.offset, Vector2(), freq.wait_time, TRANS, EASE)
	tweenShake.start()

func _on_freq_timeout():
	createShake()

func _on_duration_timeout():
	reset()
	freq.stop()

func turnMonitorOn():
	officePov.current = false
	camPov.current = true
	camHitbox.disabled = false
	Global.usage += 1

func turnMonitorOff():
	camPov.current = false
	officePov.current = true
	camHitbox.disabled = true
	Global.usage -= 1

func delEverything():
	Audio.stopBGM()
	Audio.stopMusicBox()
	Audio.stopToyStare()
	unloadChar()

func changeCam(camLoc):
	camPov.position = get_node("cameras/"+str(camLoc)).position
	lastLoc = camLoc

func ventToggle():
	camPov.current = false
	ventPov.current = true

func camToggle():
	camPov.current = true
	ventPov.current = false

func _on_powerConsumption_timeout():
	Global.power -= Global.usage
	if Global.power <= 0:
		$gameTimer.stop()
		Audio.stopBGM()
		Audio.stopToyStare()
		Audio.stopMusicBox()
		Overlay.powerOff()
		$powerText.stop()
		Global.disableDoor = true
		Global.disableFlash = true
		$office.powerDown()
		$doors.powerOff()
		$uhOh.start()
		unloadChar()

func goToMenu():
	gameLoad.load_scene(self, "res://objects/menu/menu.tscn")

func _on_gameTimer_timeout():
	Overlay.when6AM()
	delEverything()

func _on_uhOh_timeout():
	if puppetPhase == 0:
		$jackinthebox.play()
		rng.randomize()
		$uhOh.wait_time = rng.randi_range(10,15)
		$uhOh.start()
		puppetPhase = 1
		var effect = load("res://objects/fx/heavyStatic.tscn")
		var effect_instance = effect.instance()
		effect_instance.set_name("vfx")
		add_child(effect_instance)
	else:
		if has_node("vfx"):
			get_node("vfx").queue_free()
		Overlay.alive = false
		$jackinthebox.stop()
		Overlay.jumpscareMoment("puppet", 2)
