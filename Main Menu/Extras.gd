extends Node2D

onready var menu = $Selection

var tween = Tween.new()
var cam
var music

func _ready():
	add_child(tween)
	PlayerData._create_or_load_save()
	_movement()
	_add_areas()
	cam = get_parent().find_node("Camera")
	music = get_parent().find_node("music")

func _add_areas():
	for i in range(0, 13):
		menu.get_child(i).text = "..."
	
	if PlayerData.finishedAreas[0]: menu.get_child(0).text = "Вишнёвая тропа - против Папируса"
	
	if PlayerData.finishedAreas[1]: menu.get_child(1).text = "Водопадье - против Санса и Флауи"
	
	
	
	
	
var input = 0.0
var selection = 0

var canAccess = true

func _process(delta):
	input = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	
	if input != 0:
		selection += input
		if selection >= 0 and selection <= 13: _movement()
		if selection < 0: selection = 0
		if selection > 13: selection = 13
		yield(get_tree().create_timer(0.8), "timeout")
	
	if Input.is_action_just_pressed("ui_accept") and canAccess:
		_access()

func _movement():
	for i in menu.get_children():
		if i.get_index() != selection:
			tween.interpolate_property(i, "rect_scale", i.rect_scale, Vector2(1.5, 1.5), 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.interpolate_property(i, "modulate:a", i.modulate.a, 0.7, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		else:
			tween.interpolate_property(i, "rect_scale", i.rect_scale, Vector2(1.8, 1.8), 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.interpolate_property(i, "modulate:a", i.modulate.a, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(menu, "position:y", menu.position.y, - 50 * selection, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _access():
	if menu.get_child(selection).text != "...":
		cam.darken_with_set_values(0.0, 1.0, 2.0)
		tween.interpolate_property(music, "volume_db", 0.0, - 80.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		canAccess = false
		set_process(false)
		yield(get_tree().create_timer(2.2), "timeout")
		
		match selection:
			0: get_tree().change_scene("res://Cutscenes/CutsceneRuins.tscn")
			1: get_tree().change_scene("res://Cutscenes/CutsceneWaterfall.tscn")
			13: get_tree().change_scene("res://Cutscenes/Credits.tscn")
	
