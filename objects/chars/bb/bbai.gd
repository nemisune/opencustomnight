extends Node2D

onready var sprite = $sprite
onready var animation = $sprite/animation
onready var timer = $timer
onready var laugh = $sprite/laugh
var rng = RandomNumberGenerator.new()
var countdown
var phase = 0

func _ready():
	print("Little Shit loaded")

func littleShit():
	if Global.rventOcc == false && animation.current_animation != "office":
		rng.randomize()
		var spawnChance = rng.randi_range(1,30)
		if spawnChance < Global.AI["bb"]:
			Global.rventOcc = true
			animation.play("vent")
			countdown = 300 - (Global.AI["bb"]*5)

func _physics_process(_delta):
	if animation.current_animation == "vent":
		if countdown >= 0:
			countdown -= 1
		if countdown <= 0 && Global.cam == true:
			animation.play("office")
			Global.rventOcc = false
			Global.disableFlash = true
			laugh.play()
			timer.start()
		if Global.rvent == true:
			animation.play("RESET")
			Audio.blockedDoor()
			Global.rventOcc = false

func enableLight():
	animation.play("RESET")
	laugh.stop()
	Global.disableFlash = false
