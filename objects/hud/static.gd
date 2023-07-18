extends AnimatedSprite

func _on_camHUD_camChanged(_camLoc):
	staticFade()

func _on_overlay_monitorOn():
	staticFade()

func staticFade():
	$staticPlayer.play("RESET")
	$staticPlayer.play("fade")
