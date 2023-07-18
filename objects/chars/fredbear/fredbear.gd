extends Node2D

var rng = RandomNumberGenerator.new()
var phase = 0
var progress = 0
var hall = "none"

func _ready():
	$eyes/animPlayer.play("RESET")

func _on_timer_timeout():
	if Global.cam == true:
		rng.randomize()
		var spawnChance = rng.randi_range(1,40)
		if spawnChance < Global.AI["fredbear"]:
			rng.randomize()
			progress = 300 - (Global.AI["fredbear"] * 5)
			phase = 1
			var direction = rng.randi_range(1,2)
			if direction == 1:
				$eyes/animPlayer.play("left")
				hall = "left"
				$laugh.play()
			else:
				$eyes/animPlayer.play("right")
				hall = "right"
				$laugh2.play()

func _process(_delta):
	print(progress)
	if phase == 1:
		progress -= 1
	if Global.ldoor == true && hall == "left":
		phase = 0
		$eyes/animPlayer.play("RESET")
		hall = "none"
		Audio.blockedDoor()
	if Global.rdoor == true && hall == "right":
		phase = 0
		$eyes/animPlayer.play("RESET")
		hall = "none"
		Audio.blockedDoor()
	if progress <= 0 && phase == 1:
		$killTimer.start()
		var effect = load("res://objects/fx/heavyStatic.tscn")
		var effect_instance = effect.instance()
		effect_instance.set_name("vfx")
		add_child(effect_instance)
		phase = 3

func _on_killTimer_timeout():
	if has_node("vfx"):
		get_node("vfx").queue_free()
	if Overlay.alive == true:
		$eyes/animPlayer.play("RESET")
		Overlay.alive = false
		Overlay.jumpscareMoment("fredbear", 4)
