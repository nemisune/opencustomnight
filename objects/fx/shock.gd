extends CanvasLayer

func _ready():
	$dark/animation.play("play")

func _on_animation_animation_finished(anim_name):
	queue_free()
