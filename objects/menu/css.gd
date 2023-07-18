extends Node2D

var levelSetterPath = load("res://objects/menu/levelSetter.tscn")

func _ready():
	for name in ["freddy", "chica", "foxy", "bb", "jj", "toybonnie", "toychica", "scrap", "fredbear", "nightfreddy", "goldy"]:
		spawnShit(name)

func spawnShit(name):
	var character :String = name
	var levelSetter = levelSetterPath.instance()
	var host = get_node(character)
	host.add_child(levelSetter)
	print(levelSetter.position)
