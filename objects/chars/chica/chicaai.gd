extends Node2D

onready var timer = $chicaTimer
onready var killTimer = $killTimer
onready var noise = $potsnpans
onready var warning = $canvas/uhoh
var rng = RandomNumberGenerator.new()
var checks = 0

func _ready():
	if get_parent().get_name() == "main": # Checking to make sure that there's a parent node, if there isn't a parent node it won't connect any signals or change position
		print("Chicken loaded")
		var newPos = get_parent().get_node("cameras/kitchen").position # Getting the position that Chica needs to go to
		noise.position = newPos # Assigning said position
		Overlay.connect("musicSwapped", self, "musicChanged")
		noise.play()
	
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
	warning.play("on")
	print("checks met")
	noise.stop()
	timer.stop()
	killTimer.start()

func musicChanged():
	warning.play("off")
	if checks == 2:
		checks = 0
		killTimer.stop()
		timer.start()
		noise.play()
	else:
		if Overlay.alive == true:
			Overlay.alive = false
			Overlay.jumpscareMoment("chica", 1)


func killCheck():
	if Overlay.alive == true:
		Overlay.alive = false
		Overlay.jumpscareMoment("chica", 1)
