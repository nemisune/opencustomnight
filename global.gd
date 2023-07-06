extends Node
var AI := {
	"freddy":10,
	"bonnie":0,
	"chica":10,
	"foxy":10,
	"toybonnie":10,
	"toychica":10,
	"bb":10,
	"jj":10
	}
var bonnieLevel = 10
var chicaLevel = 5
var teddyLevel = 0
var tonnieLevel = 20
var thicaLevel = 20
var bbLevel = 10
var jjLevel = 10
var mangleLevel = 0

var power = 100
var usage = 1
var rdoor = false
var ldoor = false
var tvent = false
var rvent = false
var rventOcc = false
var mask = false
var cam = false
var tempTier = 1
var temperature = 70
var disableDoor = false
var disableFlash = false
var fan = true
var jumpscare = "none"
var jumpscareNow = "none"

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

