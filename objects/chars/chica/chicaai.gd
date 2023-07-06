extends Node2D

onready var timer = $chicaTimer
onready var killTimer = $killTimer
onready var noise = $potsnpans
var rng = RandomNumberGenerator.new()
var checks = 0

func _ready():
	print("Chicken loaded")
	noise.play()
	if get_parent().get_name() == "main": # Checking to make sure that there's a parent node, if there isn't a parent node it won't connect any signals or change position
		var newPos = get_parent().get_node("cameras/kitchen").position # Getting the position that Chica needs to go to
		position = newPos # Assigning said position

func timerUpdate():
	rng.randomize()
	var chance = rng.randi_range(0,39)
	print(chance)
	if chance < Global.AI["chica"]:
		checks += 1
	else:
		checks = 0
	if checks == 2:
		checksMet()

func checksMet():
	print("checks met")
	noise.stop()
	timer.stop()
	killTimer.start()

func crisisStopped():
	if checks == 2:
		checks = 0
		killTimer.stop()
		timer.start()
		noise.play()
	else:
		if Global.jumpscare == "none":
			Global.jumpscare = "chica"

func killTimer():
	if Global.cam == true:
		rng.randomize()
		var killChance = rng.randi_range(1,2)
		if killChance == 1:
				if Global.jumpscare == "none":
					Global.jumpscare = "chica"
		else:
			timer.start()
	else:
		timer.start()
