extends Node2D

onready var overlay = $overlay
onready var fuzz = $overlay/buttons/static/anim
onready var officePov = $pov
onready var camPov = $campov
onready var camControl = $overlay/buttons
onready var kitchenSounds = get_node("/root/Audio/kitchensounds")
var freddy
var chica
var bb
var jj
var tonnie
var thica

var lastLoc = "lhall"
signal camUp

func _ready():
	if Global.freddyLevel > 0:
		print("Fazbear loaded")
		freddy = preload("res://objects/chars/freddy/freddy.tscn").instance()
		add_child(freddy)
		freddy.position = $cameras/lhall.position
	if Global.chicaLevel > 0:
		print("Chica loaded")
		chica = preload("res://objects/chars/chica/chica.tscn").instance()
		add_child(chica)
		chica.position = $cameras/kitchen.position
	if Global.bbLevel > 0:
		print("Little Shit loaded")
		bb = preload("res://objects/chars/bb/bb.tscn").instance()
		add_child(bb)
		bb.position = $office.position
	if Global.jjLevel > 0:
		print("Little Shit No.2 loaded")
		jj = preload("res://objects/chars/jj/jj.tscn").instance()
		add_child(jj)
		jj.position = $office.position
	if Global.tonnieLevel > 0:
		print("Twink loaded")
		tonnie = preload("res://objects/chars/tonnie/toybonnie.tscn").instance()
		add_child(tonnie)
		tonnie.position = $office.position
	if Global.thicaLevel > 0:
		print("Toy Chicken loaded")
		thica = preload("res://objects/chars/thica/toychica.tscn").instance()
		add_child(thica)
		thica.position = $office.position
	#break
	var cadet = preload("res://objects/chars/candycadet/cadet.tscn").instance()
	add_child(cadet)
	overlay.connect("monitorOn", self, "turnMonitorOn")
	overlay.connect("monitorOff", self, "turnMonitorOff")
	overlay.connect("go2Menu", self, "goToMenu")
	camControl.connect("camChanged", self, "changeCam")
	VFX.connect("SixAM", self, "goToMenu")
	Audio.playMusicBox()
	kitchenSounds.position = $cameras/kitchen.position
	Audio.playBGM()

func loadAnimatronics():
	pass

func _process(delta):
	$powerConsumption.wait_time = 6 - Global.usage

func turnMonitorOn():
	officePov.current = false
	officePov.lock = true
	camPov.current = true
	$overlay/perspective.hide()
	if is_instance_valid(bb):
		bb.littleShit()
	if is_instance_valid(jj):
		jj.littleShit()

func turnMonitorOff():
	camPov.current = false
	officePov.lock = false
	officePov.current = true
	$overlay/perspective.show()

func changeCam(camLoc):
	fuzz.play("RESET")
	fuzz.play("unfuzz")
	camPov.position = get_node("cameras/"+str(camLoc)).position
	lastLoc = camLoc

func _on_ventsys_pressed():
	camPov.position = get_node("cameras/vent").position

func _on_camsys_pressed():
	camPov.position = get_node("cameras/"+str(lastLoc)).position

func _input(event):
	if event.is_action_pressed("fan"):
		Global.fan = !Global.fan

func musicChanged():
	chica.crisisStopped()

func _on_powerConsumption_timeout():
	Global.power -= 1

func goToMenu():
	gameLoad.load_scene(self, "res://objects/menu.tscn")

func when6AM():
	VFX.play6AM()
	Audio.DingDong()
	Audio.stopBGM()
	officePov.lock = true
	$overlay.hide()
	if is_instance_valid(freddy):
		freddy.queue_free()
	if is_instance_valid(chica):
		chica.queue_free()
