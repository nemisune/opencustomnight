extends AnimatedSprite

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	play(str(rng.randi_range(1,3)))
