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

func _ready():
	pass

func spawnChance():
	rng.randomize()
	var spawnChance = rng.randi_range(0,49)
	if spawnChance < Global.AI["toychica"]:
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
	if Global.jumpscareNow == "none":
		Global.jumpscareNow = "thica"
