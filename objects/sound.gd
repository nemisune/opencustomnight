extends Node2D

var rng = RandomNumberGenerator.new()
var song = 1

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

func playPotsPans():
	$kitchensounds/potspans.play()

func stopPotsPans():
	$kitchensounds/potspans.stop()

func toyStare():
	$toystare.play()

func stopToyStare():
	$toystare.stop()

func blockedDoor():
	$blocked.play()

func playScream():
	$scream.play()

func stopScream():
	$scream.stop()

func playBGM():
	$bgm1.play()

func stopBGM():
	$bgm1.stop()

func DingDong():
	$"6am".play()
