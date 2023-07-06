extends Node2D

onready var cameraFox = $camFoxy
onready var coveAnim = $camFoxy/piratesCove
onready var officeAnim = $officeAnimation
onready var camHitbox = $camFoxy/detectCamera
var numH = 0
var phase = 0
var progress = 0
var active = true
var lookedAt = false
var inOffice = false
var rng = RandomNumberGenerator.new()
signal dead(character)
signal makeStatic


func _ready():
	print("Foxy loaded")
	officeAnim.play("office")
	if get_parent().get_name() == "main":
		cameraFox.position = get_parent().get_node("cameras/cove").position

func _process(delta):
	print(progress)
	if lookedAt == false:
		progress += 1 + numH
		if progress > (1000 - (Global.AI["foxy"]*10)):
			rng.randomize()
			var moveChance = rng.randi_range(1,3)
			if moveChance > 1:
				phase += 1
				progress = 0
				if numH < 3:
					numH += 1
	if phase < 5:
		coveAnim.frame = phase
	elif phase >= 5:
		coveAnim.frame = 5
		if is_instance_valid(camHitbox):
			print("wow")
			camHitbox.queue_free()
	lookedAt = false
	if Global.cam == true:
		officeAnim.seek(phase)
	if Global.cam == true && phase > 8:
		rng.randomize()
		var deathChance = rng.randi_range(1,10)
		if deathChance == 1:
			if Global.jumpscare == "none":
				Global.jumpscare = "foxy"

func _on_detectCamera_area_entered(area):
	if Global.cam == true:
		progress = 0
		numH = 0
		lookedAt = true

func _on_detectCamera_area_exited(area):
	lookedAt = false
