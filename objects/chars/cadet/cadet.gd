extends Node2D

var rng = RandomNumberGenerator.new()
var quote = 1

func _on_timer_timeout():
	rng.randomize()
	quote = rng.randi_range(1,4)
	get_node("sprite/line"+str(quote)).play()
	$sprite.frame = 0
	$sprite.play("default")
