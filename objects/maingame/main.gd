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
var powerCounter
var cadet
var animatronic
var puppetPhase = 0
var lastLoc = "lhall"
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
var amplitude = 0


func _ready():
	Overlay.startGame()
	RichPresence.startNight()
	connectSignals()
	camMovement.play("yeah")
	powerCounter = Overlay.get_node("hudElements/power")
	kitchenSounds.position = $cameras/kitchen.position
	Audio.playMusicBox()
	Audio.playBGM()
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
	Overlay.connect("musicSwapped", self, "musicChanged")
	Overlay.connect("go2Menu", self, "goToMenu")
	Overlay.connect("itsOver", self, "delEverything")
	Overlay.connect("camShake", self, "startShake")

""" So basically what's going on up here is that it's preloading both the HUD and Candy Cadet animatronic so that they spawn in the office,
it then also adds those two as children. Afterwards it uses plays an animation called "yeah" for the camMovement object that was defined
earlier at the top of the script. That animation is set to loop and just makes it so the cameras automatically scroll. Then it just
defines the power counter aka the little text at the bottom left that displays your percentage of power. Then things with audio are handled.
"Audio.playMusicBox()" is a function that's run from the Global audio node to play the music box, it's also told to play the background music. 
Last but not least, the animatronics are loaded into the scene.   """

""" !! CHARACTER LOADING AND UNLOADING !! """
func load_char(animatronic):
	var string_var :String = animatronic
	if Global.AI[string_var] > 0:
		animatronic = load(str("res://objects/chars/",animatronic,"/",animatronic,".tscn")).instance()
		add_child(animatronic)
		animatronic.add_to_group("animatronics")

""" !! IF YOU WANT TO PRELOAD CHARACTERS SO NO ASSETS ARE LOADED IN DURING GAMEPLAY !!
	This code runs the risk of making things blockier/more bloated but for the time being that's all I got.
	Study a little yourself maybe!
	if Global.freddyLevel > 0:
		print("Fazbear loaded")
		freddy = preload("res://objects/chars/freddy/freddy.tscn").instance()
		add_child(freddy)
		freddy.add_to_group("animatronics")
		freddy.position = $cameras/lhall.position """

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
	$office/desk.queue_free()
	$doors.queue_free()

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
	Global.power -= 0.5 + Global.usage
	if Global.power <= 0:
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
