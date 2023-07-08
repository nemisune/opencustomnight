extends AnimatedSprite

onready var fade = $desk/fade

func _ready():
	$desk.playing = Global.fan
	$desk/fan.play()

func _input(event):
	if event.is_action_pressed("fan"):
		$desk/click.play()
		Global.fan = !Global.fan
		if Global.fan == false:
			Global.usage -= 1
			$desk.playing = false
			fade.play("off")
		else:
			Global.usage += 1
			$desk.playing = true
			fade.play("on")
