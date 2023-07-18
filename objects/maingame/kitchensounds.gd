extends Node2D

var rng = RandomNumberGenerator.new()

func playMusicBox():
	var song = rng.randi_range(1,5)
	get_node("musicbox/"+str(song)).play()
