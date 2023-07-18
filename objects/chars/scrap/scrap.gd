extends Node2D

var rng = RandomNumberGenerator.new()
var phase = 0
onready var sprite = $sprite

func _ready():
	print("Scrap loaded")
	$buttonsprite.hide()

func scrapStart():
	$timer.start()

func scrapStop():
	$timer.stop()

func _on_timer_timeout():
	if Global.cam == true && phase < 2:
		$buttonsprite.show()
		rng.randomize()
		var advanceChance = 3
		if advanceChance < Global.AI["scrap"]:
			phase += 1
			sprite.frame = phase
	elif Global.cam == true && phase == 2:
		if Global.jumpscare == "none":
			Global.jumpscare = "scrap"

func _on_Button_pressed():
	var effect = load("res://objects/fx/shock.tscn")
	var effect_instance = effect.instance()
	effect_instance.set_name("vfx")
	add_child(effect_instance)
	$shocktimer.start()
	$shock.play()
	Global.power -= 1
	if phase == 2:
		phase = 1
		sprite.frame = phase

func _on_shocktimer_timeout():
	pass
