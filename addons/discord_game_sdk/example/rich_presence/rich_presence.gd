extends Node2D

func _ready():
	update_activity()

func update_activity() -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state("In Menu")
	activity.set_details("")

	var assets = activity.get_assets()
	assets.set_large_image("512")
	assets.set_large_text("Test")
	assets.set_small_image("512")
	assets.set_small_text("Test")
	
#	var timestamps = activity.get_timestamps()
#	timestamps.set_start(OS.get_unix_time() + 100)
#	timestamps.set_end(OS.get_unix_time() + 500)

	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))

func startNight() -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state("Night 0")
	activity.set_details("In Game")

	var assets = activity.get_assets()
	assets.set_large_image("512")
	assets.set_large_text("Test")
	assets.set_small_image("512")
	assets.set_small_text("Test")
	
	var timestamps = activity.get_timestamps()
	timestamps.set_end(OS.get_unix_time() + 270)

	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))

func deadAsHell() -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state("What a dumbass!")
	activity.set_details("Dead.")

	var assets = activity.get_assets()
	assets.set_large_image("512")
	assets.set_large_text("Test")
	assets.set_small_image("512")
	assets.set_small_text("Test")

	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))
