extends Node2D

signal SixAM
var scrambleAmount = 0
onready var scrambleAnim = $canvas/animplayer

func play6AM():
	get_node("canvas/6amScene/6amplayer").play("play")

func _on_6amplayer_animation_finished(anim_name):
	emit_signal("SixAM")

func playStatic():
	$canvas/fuzzy/staticAnimation.play("RESET")
	$canvas/fuzzy/staticAnimation.play("play")

func clearCamFX():
	$canvas/fuzzy/staticAnimation.play("RESET")

func scrambleCams():
	scrambleAmount = 250 + (Global.bonnieLevel*20)

func dimLights():
	$canvas/lightsdimming/dimAnim.play("playingDim")

func stopDimming():
	$canvas/lightsdimming/dimAnim.play("RESET")

func _process(delta):
	if scrambleAmount > 0:
		scrambleAmount -= 1
		scrambleAnim.play("scramble")
