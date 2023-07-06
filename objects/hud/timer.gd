extends Label

var time = 0
signal update_time

func _process(delta):
	time += delta
	var mills = fmod(time,1)*1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60)/60
	
	var time_passed = "%02d : %02d : %02d" % [mins, secs,mills]
	text = time_passed


