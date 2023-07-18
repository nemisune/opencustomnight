extends AnimatedSprite

onready var fade = $desk/fade
var rng = RandomNumberGenerator.new()

func _ready():
	Global.fan = true
	$animation.play("RESET")
	$desk.playing = Global.fan
	$desk/fan.play()

#func _input(event):
#	if event.is_action_pressed("fan"):
#		$desk/click.play()
#		Global.fan = !Global.fan
#		if Global.fan == false:
#			Global.usage -= 1
#			$desk.playing = false
#			fade.play("off")
#		else:
#			Global.usage += 1
#			$desk.playing = true
#			fade.play("on")

func playShake():
	$animation.play("shake")

func powerDown():
	$animation.play("poweroff")
	$desk/fan.stop()
	$powerdown.play()

func _on_Timer_timeout():
	if Global.power > 0:
		var flickerAnim = rng.randi_range(1,4)
		if flickerAnim < 4:
			$animation.play("dimming"+str(flickerAnim))
