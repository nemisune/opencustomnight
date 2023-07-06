extends Node2D

var rng = RandomNumberGenerator.new()
signal swapFigure

func _ready():
	if get_parent().get_name() == "main":
		connect("swapFigure", get_parent(), "switchFigure")

func switchBonnie():
	$sprite.frame = 1

func switchFoxy():
	$sprite.frame = 0
