extends Node2D

var grabLevel

func _ready():
	grabLevel = get_parent().get_name()
	
func _on_turnUp_pressed():
	if Global.AI[grabLevel] < 20:
		Global.AI[grabLevel] += 1
		$ting.play()

func _on_turnDown_pressed():
	if Global.AI[grabLevel] > 0:
		Global.AI[grabLevel] -= 1
		$ting.play()

func _process(_delta):
	$aiLevel.text = str(Global.AI[grabLevel])
