extends Node2D

func _ready():
	_update_activity(" ", " ")
	_update_time()

func _update_activity(state, details):
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state(state)
	activity.set_details(details)
	
	var assets = activity.get_assets()
	assets.set_large_image("coverartchione")
	assets.set_large_text("ut icebound")
	
	var timestamps = activity.get_timestamps()
	timestamps.set_start(OS.get_unix_time())
	yield(get_tree().create_timer(0.5), "timeout")
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))
	

func _update_time():
	var activity = Discord.Activity.new()
	
	var timestamps = activity.get_timestamps()
	timestamps.set_start(OS.get_unix_time())
	
