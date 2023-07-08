extends Node2D

onready var sprite = $sprite
onready var spawnTimer = $spawnTimer
onready var animation = $sprite/animPlayer
onready var animtree = $sprite/animTree
onready var hitbox = $sprite/hitbox
onready var hitshape = $sprite/hitbox/hitshape
onready var deathTimer = $deathTimer
var rng = RandomNumberGenerator.new()
var phase = 0
var exposure = 0
var exposureRate = 1
signal killHim

func _ready():
	if get_parent().get_name() == "main": # Checking to make sure that there's a parent node, if there isn't a parent node it won't connect any signals or change position
		connect("killHim", get_parent(), "jumpscareNow")

func spawnChance():
	rng.randomize()
	var spawnChance = rng.randi_range(0,49)
	if spawnChance < Global.AI["toybonnie"]:
		VFX.dimLights()
		animation.play("entering")
		spawnTimer.stop()
		phase = 1
		rng.randomize()
		exposure = rng.randi_range(0,99)
		deathTimer.start()
		Audio.toyStare()

func _physics_process(delta):
	if Global.mask == true && phase == 1:
		exposure += exposureRate
	if exposure >= 200:
		exposure = 0
		phase = 0
		animation.play_backwards("entering")
		VFX.stopDimming()
		spawnTimer.start()
		deathTimer.stop()
		Audio.stopToyStare()

func mouseTouchingHitbox():
	exposureRate = 2

func mouseLeavesHitbox():
	exposureRate = 1

func deathTimer():
	sprite.hide()
	VFX.stopDimming()
	Audio.stopToyStare()
	if Global.jumpscareNow == "none":
		Global.jumpscareNow = "tonnie"
		emit_signal("killHim")
