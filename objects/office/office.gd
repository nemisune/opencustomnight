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
			$desk.playing = false
			fade.play("off")
		else:
			$desk.playing = true
			fade.play("on")
