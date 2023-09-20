extends Node2D

var phase = 0
var reactTime = 0
var rng = RandomNumberGenerator.new()

func _ready():
	print("Goldy loaded")
	Overlay.connect("monitorOff", self, "appear")
	Overlay.connect("monitorOn", self, "die") 
	Overlay.connect("maskToggled", self, "die") 

func appear():
	if phase == 0:
		rng.randomize()
		var spawnChance = rng.randi_range(1,40)
		if spawnChance < Global.AI["goldy"] + 1:
			$bg/anims.play("appear")
			reactTime = 250 - Global.AI["goldy"]
			phase = 1

func _process(_delta):
	if phase == 1:
		reactTime -= 1
	if phase == 1 && reactTime <= 0:
		if Overlay.alive == true:
			Overlay.alive = false
			Overlay.jumpscareMoment("goldy", 2)
			phase = 2

func die():
	if phase == 1 && Global.mask == true:
		phase = 0
		$bg/anims.play("dip")
	elif phase == 1 && Global.cam == true:
		phase = 0
		$bg/anims.play("dip")
