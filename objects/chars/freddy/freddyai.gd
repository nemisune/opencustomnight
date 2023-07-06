extends Node2D

onready var timer = $freddyTimer
onready var sprite = $fredSprite
onready var animation = $fredSprite/fredAnimation
onready var laugh = $laugh
onready var killTimer = $killTimer
"""
Onready variables are basically variables in this case are basically used as a way to quick reference an object in a scene.
I could just type out $fredSprite/fredAnimation every time I have to get it for some reason, but the issue with that is that
if I ever *change* the location of this sprite for whatever reason, I'll need to update every single line that references/uses
that object. By using an onready var, I can just update the path there and now every other line by extension is updated. It also
just looks cleaner lol.
"""
var watched = null
var progress = 0
var rng = RandomNumberGenerator.new()
var numA
var numB
"""
These are regular variables that don't reference anything and just hold values. I put "watched" as "null" just in case
something happens but I doubt it will. The watched value just controls whether Freddo is being watched or not. Progress
is uhhh, progress. RNG is also uhhh, RNG. NumA and NumB aren't assigned a value here yet since they're going to be given
specific values for when Fred calculates his next move.
"""
signal makeStatic # Just a signal that we're going to use later for when Freddy should make static appear to mask his movement

func _ready(): # THE FUNCTION THAT IS RUN AT THE START OF THIS SCENE
	print("Fazbear loaded") # Prints to the console that Freddy is in fact loaded into the scene
	animation.play("freddy") # This plays the Freddy animation that the code will control as he updates
	if get_parent().get_name() == "main": # Checking to make sure that there's a parent node, if there isn't a parent node it won't connect any signals or change position
		connect("makeStatic", get_parent(), "camInterfere") # Connecting a signal, will explain a bit lower
		var newPos = get_parent().get_node("cameras/lhall").position # Getting the position that Freddy needs to go to
		position = newPos # Assigning said position

func _on_freddyTimer_timeout(): # This function is run every time the "freddyTimer" node hits zero
	numA = rng.randi_range(0, (Global.AI["freddy"] - 1)) # Picking a random number between 0 and one less than Freddy's AI level.
	numB = floor((Global.temperature-60)/5) # Gets the tier of temperature in intervals of 4
	progress += numA + numB # Adding everything together
	var animPhase = floor(progress/100) # Creating a value that will take Freddy's progress and turn it into a single number
	animation.seek(animPhase) # Taking the animation player and seeking out the frame that corresponds with the phase we got from above
	if progress >= 400 && Global.ldoor == true: # Self explanatory stuff here. Use your peepers.
		Audio.blockedDoor()
		progress = 0
		animation.seek(0)
		laughChance() # Calls a laugh function
	if progress >= 500:
		progress = 0
		timer.stop()
		animation.seek(0)
		if Global.jumpscare == "none":
			Global.jumpscare = "freddy"

func laughChance(): # Adds a tiny bit more flavor by making Freddy have a 1/3 chance of laughing every time he's sent back.
	rng.randomize()
	var chance = rng.randi_range(1,3)
	if chance == 1:
		laugh.play()

func _on_fredSprite_frame_changed(): # When Freddy's sprite changes, this function is called
	if watched == true:
		emit_signal("makeStatic") # Take a guess on what this does.

func _on_area_area_entered(area): # "Am I being watched?"
	watched = true

func _on_area_area_exited(area): # "No, I'm not being watched."
	watched = false
