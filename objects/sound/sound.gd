extends Node2D

var rng = RandomNumberGenerator.new()
var song = 1
var title
var randomSong

func playMusicBox():
	rng.randomize()
	song = rng.randi_range(1,4)
	get_node("kitchensounds/musicbox"+str(song)).play()

func restartMusicBox():
	get_node("kitchensounds/musicbox"+str(song)).stop()
	rng.randomize()
	song = rng.randi_range(1,4)
	get_node("kitchensounds/musicbox"+str(song)).play()

func stopMusicBox():
	get_node("kitchensounds/musicbox"+str(song)).stop()

func toyStare():
	$toystare.play()

func stopToyStare():
	$toystare.stop()

func blockedDoor():
	$blocked.play()

func playScream():
	pass

func stopScream():
	pass

func playBGM():
	rng.randomize()
	randomSong = 10
	get_node("bgm"+str(randomSong)).play()
	title = get_node("bgm"+str(randomSong)).editor_description

func stopBGM():
	get_node("bgm"+str(randomSong)).stop()

func DingDong():
	$"6am".play()
