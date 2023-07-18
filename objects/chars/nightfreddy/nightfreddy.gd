extends Node2D

onready var freddle = load("res://objects/chars/nightfreddy/freddle.tscn")
onready var poof = load("res://objects/fx/poof.tscn")
var rng = RandomNumberGenerator.new()
var freddlePhase = 0
var dadPhase = 0

func _ready():
	if get_parent().get_name() == "main":
		print("Freddad loaded")
		Overlay.connect("monitorOn", self, "getBusy")
		Overlay.connect("monitorOff", self, "stopIt")

func getBusy():
	if dadPhase < 7:
		$Timer.start()

func stopIt():
	if dadPhase < 7:
		$Timer.stop()

func _on_Timer_timeout():
	rng.randomize()
	var spawnChance = rng.randi_range(1,40)
	if spawnChance <= Global.AI["nightfreddy"]:
		if freddlePhase < 5:
			freddlePhase += 1
			var freddy_instance = freddle.instance()
			freddy_instance.set_name("freddo"+str(freddlePhase))
			add_child(freddy_instance)
			freddy_instance.position = get_node("fred"+str(freddlePhase)).position
		dadPhase += 1
	if dadPhase > 7 && Overlay.alive == true:
		$killTimer.start()
		$Timer.stop()
		var effect = load("res://objects/fx/heavyStatic.tscn")
		var effect_instance = effect.instance()
		effect_instance.set_name("vfx")
		add_child(effect_instance)

func _input(event):
	if Global.flash == true && freddlePhase > 0:
		get_node("freddo"+str(freddlePhase))

func _process(delta):
	if Input.is_action_pressed("flashlight") && freddlePhase > 0:
		rng.randomize()
		var dieChance = rng.randi_range(1,20)
		if dieChance == 1:
			if has_node("freddo"+str(freddlePhase)):
				var smoke_instance = poof.instance()
				smoke_instance.set_name("freddo"+str(freddlePhase))
				add_child(smoke_instance)
				smoke_instance.position = get_node("fred"+str(freddlePhase)).position
				get_node("freddo"+str(freddlePhase)).queue_free()
				freddlePhase -= 1
				dadPhase -= 1

func _on_killTimer_timeout():
	if has_node("vfx"):
		get_node("vfx").queue_free()
	if Overlay.alive == true:
		Overlay.alive = false
		Overlay.jumpscareMoment("nightfreddy", 4)
