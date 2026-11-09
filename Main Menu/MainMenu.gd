extends Node2D


onready var title = $Title
onready var topBorder = $TopBorder
onready var textBorder = $TextBorder

onready var start = $Buttons / Start
onready var options = $Buttons / Options
onready var extras = $Buttons / Extras
onready var quit = $Buttons / Quit
onready var soul = $Soul


onready var sans = $Art / Sans
onready var mettaton = $Art / Mettaton
onready var rp = $Art / RiverPerson

var tween = Tween.new()

var canMoveTitle = false

func _ready():
	get_tree().paused = false
	
	$intro.play()
	$chimes.play()
	
	RichPresence._update_activity("...", "Menu")
	PlayerData._create_or_load_save()
	PlayerData._loadCurrentArea()
	
	topBorder.position.y = - 100
	
	textBorder.position.y = - 50
	textBorder.modulate.a = 0
	
	title.position = Vector2(320, 260)
	title.modulate.a = 0.0
	
	soul.modulate.a = 0.0
	
	$MenuSettings.set_process(false)
	$Extras.set_process(false)
	add_child(tween)
	
	$shader.modulate.a = 0.0
	
	tween.interpolate_property(title, "position:y", 280, 240, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(title, "scale", Vector2(0.0, 0.0), Vector2(2.5, 2.5), 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(title, "modulate:a", 0.0, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(1), "timeout")
	canMoveTitle = true

var index = 0

var is_selecting = false
var is_in_options = false
var is_in_extras = false
var canSelect = true
var select_ = false

var tweening_ = false

func _process(delta):
	index += 1
	
	if index >= 40 and canMoveTitle == true:
		index = 40
	
	if is_selecting == true and index >= 80: _selecting()
	
	if not PlayerData.addParticles:
		$Art / Sans / soulpart.emitting = false
		$Particles2D.emitting = false
	
var selection = 0.0

func _selecting():
	if select_ == true:
		$Buttons.get_child(selection).modulate = Color(1, 1, 1)
		selection += int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
		
		if selection > 3: selection = 0
		if selection < 0: selection = 3
		
		$Buttons.get_child(selection).modulate = Color(1, 1, 0)
		
		tween.interpolate_property(
			soul, "position", 
			soul.position, Vector2(255, $Buttons.get_child(selection).position.y), 0.5, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		tween.start()
		
		if Input.is_action_just_pressed("ui_accept"):
			if selection == 0 and canSelect == true:
				_start_game()
			
			if selection == 1 and tweening_ == false:
				is_in_options = true
				is_selecting = false
				tween.interpolate_property($Camera, "position:x", $Camera.position.x, 1200, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
				tween.start()
				$MenuSettings.set_process(true)
				
				tweening_ = true
				yield(get_tree().create_timer(1.1), "timeout")
				tweening_ = false
			
			if selection == 2 and tweening_ == false:
				is_in_extras = true
				is_selecting = false
				tween.interpolate_property($Camera, "position:x", $Camera.position.x, - 600, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
				tween.start()
				$Extras.set_process(true)
				
				tweening_ = true
				yield(get_tree().create_timer(1.1), "timeout")
				tweening_ = false
			
			if selection == 3: OS.kill(OS.get_process_id())
	else:
		tween.interpolate_property(
			soul, "position", 
			soul.position, Vector2(255, $Buttons.get_child(selection).position.y), 0.5, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)

func _start_game():
	set_process(false)
	canSelect = false
	$Camera.darken_with_set_values(0.0, 1.0, 2.0)
	tween.interpolate_property(
		$music, "volume_db", 
		$music.volume_db, - 40.0, 1.8, 
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	tween.interpolate_property($Camera.get_child(0), "modulate:a", 0.4, 0.0, 3.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Light2D2, "energy", 2.7, 0.0, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Art / Sans / Light2D, "energy", 2.7, 0.0, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(4.0), "timeout")
	if not PlayerData.currentArea: get_tree().change_scene("res://Cutscenes/CutsceneRuins.tscn")
	else: get_tree().change_scene(PlayerData.currentArea)
	

func _menu_art():
	tween.interpolate_property($Camera.get_child(0), "modulate:a", 0.0, 0.4, 18.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($shader, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(sans, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(mettaton, "modulate:a", 0.0, 0.8, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(rp, "modulate:a", 0.0, 0.7, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _menu_art_animate():
	sans.position.y += cos(index / 40) / 15
	rp.position.y += cos(index / 40) / 18

func _input(event):
	if event.is_action_pressed("ui_accept") and canMoveTitle == true:
		is_selecting = true
		canMoveTitle = false
		$Particles2D.emitting = true
		$music.playing = true
		tween.interpolate_property(title, "position:y", 240, 50, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(title, "scale", Vector2(2.5, 2.5), Vector2(1.5, 1.5), 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		tween.interpolate_property(topBorder, "position:y", - 100, 50, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(topBorder, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		
		yield(get_tree().create_timer(0.25), "timeout")
		tween.interpolate_property(textBorder, "position:y", - 50, 90, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(textBorder, "modulate:a", 0.0, 1.0, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		
		yield(get_tree().create_timer(0.2), "timeout")
		tween.interpolate_property(start, "position:x", - 100, 320, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(options, "position:x", - 100, 320, 1.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(extras, "position:x", - 100, 320, 1.9, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(quit, "position:x", - 100, 320, 2.1, Tween.TRANS_QUINT, Tween.EASE_OUT)
		
		yield(get_tree().create_timer(0.45), "timeout")
		_menu_art()
		_menu_art_animate()
		
		yield(get_tree().create_timer(0.25), "timeout")
		tween.interpolate_property(soul, "modulate:a", 0.0, 1.0, 6.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		yield(get_tree().create_timer(0.5), "timeout")
		select_ = true
	
	if event.is_action_pressed("ui_cancel") and is_in_extras == true and tweening_ == false:
		tween.interpolate_property($Camera, "position:x", $Camera.position.x, 320, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tween.start()
		is_selecting = true
		is_in_extras = false
		$Extras.set_process(false)
		
		tweening_ = true
		yield(get_tree().create_timer(1.1), "timeout")
		tweening_ = false
		
	if event.is_action_pressed("ui_cancel") and is_in_options == true and tweening_ == false:
		tween.interpolate_property($Camera, "position:x", $Camera.position.x, 320, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tween.start()
		is_selecting = true
		is_in_options = false
		$MenuSettings.set_process(false)
		
		tweening_ = true
		yield(get_tree().create_timer(1.1), "timeout")
		tweening_ = false
