extends Node2D

var ldoor = false
var rdoor = false
var rvent = false
var tvent = false
onready var lsprite = $ldoor
onready var rsprite = $rdoor
onready var vsprite = $vdoor
onready var sfx = $door

func _input(event):
	if Global.disableDoor == false:
		if event.is_action_pressed("ldoor"):
			sfx.play()
			ldoor = !ldoor
			Global.ldoor = !Global.ldoor
			lsprite.play("play", (!ldoor))
			if Global.ldoor == true:
				Global.usage += 1
			else:
				Global.usage -= 1
		elif event.is_action_pressed("rdoor"):
			sfx.play()
			rdoor = !rdoor
			Global.rdoor = !Global.rdoor
			rsprite.play("play", (!rdoor))
			if Global.rdoor == true:
				Global.usage += 1
			else:
				Global.usage -= 1
		elif event.is_action_pressed("rvent"):
			sfx.play()
			rvent = !rvent
			Global.rvent = !Global.rvent
			vsprite.play("play", (!rvent))
			if Global.rvent == true:
				Global.usage += 1
			else:
				Global.usage -= 1

func powerOff():
	Global.disableDoor = true
	if Global.ldoor == true:
		Global.ldoor = false
		lsprite.play("play", true)
		Global.usage -= 1
		sfx.play()
	if Global.rdoor == true:
		Global.rdoor = false
		rsprite.play("play", true)
		Global.usage -= 1
		sfx.play()
	if Global.rvent == true:
		Global.rvent = false
		vsprite.play("play", true)
		Global.usage -= 1
		sfx.play()
