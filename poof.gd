extends AnimatedSprite


func _ready():
	play("default")

func _on_poof_animation_finished():
	queue_free()
