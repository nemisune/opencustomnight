extends Node2D

onready var animation = $player
var skippable = true

func _ready():
	Overlay.hide()
	animation.play("warning")
	$main/cursor/cursoranim.play("playing")
	$music.play()
	var buttons = get_tree().get_nodes_in_group("button")
	for inst in buttons:
		inst.connect("mouse_entered", self, "checking")

func _input(event):
	if event.is_action_pressed("ui_accept") && skippable == true:
		$player.play("main")

func _process(_delta):
	if $main/customGo.is_hovered():
		$main/cursor.position.y = 789
	elif $main/settingsGo.is_hovered():
		$main/cursor.position.y = 830
	elif $main/creditsGo.is_hovered():
		$main/cursor.position.y = 868
	elif $main/testGo.is_hovered():
		$main/cursor.position.y = 750
	else:
		$main/cursor.position.y = -395

func checking():
	$hover.play()

func _on_settingsGo_pressed():
	animation.play("go2settings")
	$select.play()

func _on_settingsBack_pressed():
	animation.play_backwards("go2settings")
	$select.play()

func _on_returnCSS_pressed():
	animation.play_backwards("go2custom")
	$select.play()

func _on_customGo_pressed():
	animation.play("go2custom")
	$select.play()

func _on_creditsGo_pressed():
	animation.play("go2credits")
	$select.play()

func _on_returnCredits_pressed():
	animation.play_backwards("go2credits")
	$select.play()

func _on_player_animation_finished(anim_name):
	if anim_name == "warning":
		skippable = false

func _on_begin_pressed():
	$gl.position = $camera.position
	$gl/glplayer.play("goodluck")

func _on_glplayer_animation_finished(_anim_name):
	gameLoad.load_scene(self, "res://objects/maingame/main.tscn")

func _on_testGo_pressed():
	$gl.position = $camera.position
	$gl/glplayer.play("goodluck")
