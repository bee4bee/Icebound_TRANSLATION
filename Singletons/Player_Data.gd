extends Node

var Name: = ""

var GlobalPosition = Vector2.ZERO
var playerSpeed = Vector2.ZERO
var isPaused = false
var isInMenu = false

var didSansDodge = false

var SnowdinDeath = false
var WaterfallDeath = false


var addLights = true
var addParticles = true


func _tempSlowdown(time: float = 0.25):
	var tween = Tween.new()
	add_child(tween)
	yield(get_tree().create_timer(0.1), "timeout")
	AudioServer.set_bus_effect_enabled(0, 1, true)
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 0.4, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(AudioServer.get_bus_effect(0, 1), "pitch_scale", Engine.time_scale, 0.4, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(time), "timeout")
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 1.0, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(AudioServer.get_bus_effect(0, 1), "pitch_scale", Engine.time_scale, 1.0, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.7), "timeout")
	AudioServer.set_bus_effect_enabled(0, 1, false)

func _shakeobj(object):
	yield(get_tree().create_timer(0.07, false), "timeout")
	object.position.x -= 6
	yield(get_tree().create_timer(0.07, false), "timeout")
	object.position.x += 11
	yield(get_tree().create_timer(0.07, false), "timeout")
	object.position.x -= 8
	yield(get_tree().create_timer(0.07, false), "timeout")
	object.position.x += 5
	yield(get_tree().create_timer(0.07, false), "timeout")
	object.position.x -= 2

func _tempStop():
	
	get_tree().paused = true
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().paused = false

var borderOn = false

var blankexpr = []
var blankframe = []

var defaultWindowSize = Vector2(700, 480)

func _ready():
	for i in 100:
		blankexpr.append("0")
		blankframe.append(0)

func _input(event):
	if Input.is_action_just_pressed("togglefullscreen"):
		if not OS.window_fullscreen:
			OS.window_fullscreen = true
			Border.find_node("SecondaryFC").show()
		else:
			OS.window_fullscreen = false
			Border.find_node("SecondaryFC").hide()
			OS.window_size = defaultWindowSize
			OS.window_position = OS.get_screen_size() / 2 - OS.window_size / 2
	

const SAVE_GAME_PATH: = "user://save0.json"
var currentArea: = ""
var finishedAreas: = [
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false
]

var madePastWaterfallIntro = false



var isBorderOn = false
var items = ["", "", "", ""]

func _loadCurrentArea():
	if not finishedAreas[0]: currentArea = "res://Cutscenes/CutsceneRuins.tscn"
	elif not finishedAreas[1]: currentArea = "res://Cutscenes/CutsceneWaterfall.tscn"
	
	if finishedAreas[1]: currentArea = "res://Overworld/Rooms/WaterfallChamber1.tscn"

var _save: = SaveGameAsJSON.new()

func _create_or_load_save() -> void :
	if _save.save_exists(): _save.load_savegame()
	else:
		_save.Name = ""
		_save.currentArea = "res://Cutscenes/CutsceneRuins.tscn"
		_save.finishedAreas = [false, false, false, false, false, false, false, false, false, false, false, false, false]
		_save.madePastWaterfallIntro = madePastWaterfallIntro
		
		_save.write_savegame()

	currentArea = _save.currentArea
	finishedAreas = _save.finishedAreas
	madePastWaterfallIntro = _save.madePastWaterfallIntro
	

func _save_game() -> void :
	_save.Name = Name
	_save.currentArea = currentArea
	_save.finishedAreas = finishedAreas
	_save.madePastWaterfallIntro = madePastWaterfallIntro
	
	_save.write_savegame()
	print("v")


var _file: = File.new()




func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)

func write_savegame() -> void :
	var error: = _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Couldn't open the file %s. Aborting save operation. Error code: %s" %
		[SAVE_GAME_PATH, error])
		print("error during saving")
		return
	else: print("save successful!")
	
	var data: = {
		"name": Name, 
		"current_area": currentArea, 
		"finished_areas": finishedAreas, 
		"made_past_waterfall_intro": madePastWaterfallIntro
		
	}
	
	var json_string: = JSON.print(data)
	_file.store_string(json_string)
	_file.close()


func load_savegame() -> void :
	var error: = _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Couldn't open the file %s. Aborting load operation. Error code: %s" %
		[SAVE_GAME_PATH, error])
		return
	
	var content: = _file.get_as_text()
	_file.close()
	
	var data: Dictionary = JSON.parse(content).result
	Name = data.name
	currentArea = data.current_area
	finishedAreas = data.finished_areas
	madePastWaterfallIntro = data.made_past_waterfall_intro
	
