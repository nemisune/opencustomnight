extends ColorRect

func _ready():
	$usageanimation.play("working")

func _process(_delta):
	$usageanimation.seek(Global.usage)
