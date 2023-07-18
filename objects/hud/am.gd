extends RichTextLabel

var hour = 12

func _on_Timer_timeout():
	if hour == 12:
		hour = 1
	else:
		hour += 1
	text = str(hour)+("AM")

func resetLol():
	hour = 12
	text = str(hour)+("AM")
