class_name SaveGameAsJSON
extends Reference

var Name = ""

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

var _file: = File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)

func write_savegame() -> void :
	var error: = _file.open_encrypted_with_pass(SAVE_GAME_PATH, File.WRITE, OS.get_unique_id())
	
	if error != OK:
		printerr("Couldn't open the file %s. Aborting save operation. Error code: %s" %
		[SAVE_GAME_PATH, error])
		return
	else: print("save successful!")
	var data: = {
		"name": PlayerData.Name, 
		"current_area": PlayerData.currentArea, 
		"finished_areas": PlayerData.finishedAreas, 
		"made_past_waterfall_intro": PlayerData.madePastWaterfallIntro
		
	}
	
	var json_string: = JSON.print(data)
	_file.store_string(json_string)
	_file.close()


func load_savegame() -> void :
	var error: = _file.open_encrypted_with_pass(SAVE_GAME_PATH, File.READ, OS.get_unique_id())
	
	if error != OK:
		printerr("Couldn't open the file %s. Aborting load operation. Error code: %s" %
		[SAVE_GAME_PATH, error])
		return
	
	var content: = _file.get_as_text()
	_file.close()
	
	var data: Dictionary = JSON.parse(content).result
	Name = data.name
	PlayerData.Name = data.name
	currentArea = data.current_area
	PlayerData.currentArea = data.current_area
	finishedAreas = data.finished_areas
	PlayerData.finishedAreas = data.finished_areas
	madePastWaterfallIntro = data.made_past_waterfall_intro
	PlayerData.madePastWaterfallIntro = data.made_past_waterfall_intro
	
	
