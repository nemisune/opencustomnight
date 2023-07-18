extends Node
var AI := {
	"cadet":1,
	"freddy":10,
	"bonnie":0,
	"chica":10,
	"foxy":10,
	"toybonnie":10,
	"toychica":10,
	"bb":10,
	"jj":10,
	"scrap":10,
	"fredbear":10,
	"nightfreddy":10,
	"goldy":10
	}
var mode = "menu"
var power = 100
var usage = 0
var rdoor = false
var ldoor = false
var tvent = false
var rvent = false
var rventOcc = false
var mask = false
var cam = false
var flash = false
var povLock = false
var temperature = 70
var disableDoor = false
var disableFlash = false
var fan = true
var quality = 1
var jumpscare = "none"
var jumpscareNow = "none"

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
