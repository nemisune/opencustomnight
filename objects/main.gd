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
var overlay
var office
var powerCounter
var animatronic
var lastLoc = "lhall"
signal camUp
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
var amplitude = 0


func _ready():
	overlay = preload("res://objects/hud/overlay.tscn").instance()
	var cadet = preload("res://objects/chars/cadet/cadet.tscn").instance()
	add_child(overlay)
	add_child(cadet)
	camMovement.play("yeah")
	powerCounter = get_node("overlay/hudElements/power")
	kitchenSounds.position = $cameras/kitchen.position
	Audio.playMusicBox()
	Audio.playBGM()
	VFX.connect("SixAM", self, "goToMenu")
	for animatronic in ["freddy", "chica", "foxy", "bb", "jj", "toybonnie", "toychica"]:
		load_char(animatronic)

func _input(event):
	if Input.is_key_pressed(KEY_BACKSLASH):
		print("cheater!")
		when6AM()

""" So basically what's going on up here is that it's preloading both the HUD and Candy Cadet animatronic so that they spawn in the office,
it then also adds those two as children. Afterwards it uses plays an animation called "yeah" for the camMovement object that was defined
earlier at the top of the script. That animation is set to loop and just makes it so the cameras automatically scroll. Then it just
defines the power counter aka the little text at the bottom left that displays your percentage of power. Then things with audio are handled.
"Audio.playMusicBox()" is a function that's run from the Global audio node to play the music box, it's also told to play the background music.
Then it connects the "SixAM" signal from the VFX global node. Last but not least, the animatronics are loaded into the scene.   """

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

func startShake(duration = 2.5, frequency = 20, amplitude = 27):
	print("going")
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
	print("Working")
	officePov.current = false
	officePov.lock = true
	camPov.current = true
	camHitbox.disabled = false
	Global.usage += 1
	if has_node("bb"):
		get_node("bb").littleShit()
	if has_node("jj"):
		get_node("jj").littleShit()

func turnMonitorOff():
	camPov.current = false
	officePov.lock = false
	officePov.current = true
	camHitbox.disabled = true
	Global.usage -= 1
	if Global.jumpscare != "none":
		officePov.lock = true
		startShake()
		overlay.jumpscare()
		Audio.playScream()

func jumpscareNow():
	if Global.cam == true:
		turnMonitorOff()
	officePov.lock = true
	startShake()
	overlay.jumpscare()
	Audio.playScream()

func changeCam(camLoc):
	camPov.position = get_node("cameras/"+str(camLoc)).position
	lastLoc = camLoc

func ventToggle():
	camPov.current = false
	ventPov.current = true

func camToggle():
	camPov.current = true
	ventPov.current = false

func musicChanged():
	if has_node("chica"):
		get_node("chica").crisisStopped()

func _on_powerConsumption_timeout():
	Global.power -= 1

func camInterfere():
	VFX.playStatic()

func goToMenu():
	unloadChar()
	Audio.stopBGM()
	Audio.stopMusicBox()
	Global.jumpscare = "none"
	gameLoad.load_scene(self, "res://objects/menu.tscn")

func when6AM():
	VFX.play6AM()
	Audio.stopBGM()
	Audio.stopMusicBox()
	officePov.lock = true

