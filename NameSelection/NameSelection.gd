extends Node2D

onready var cam = $Camera

onready var keys = $Keys
var currentKey

onready var playerName = $Name
onready var nameStr = ""

onready var title = $Title

onready var soul = $Soul

var tween = Tween.new()

var row = 0.0
var column = 0.0

var stage2 = false
var stage1 = true
var trueName = false

func _ready():
	
	PlayerData._create_or_load_save()
	if PlayerData.Name != "": get_tree().change_scene("res://Main Menu/MainMenu.tscn")
	
	RichPresence._update_activity("...", "...")
	$static .playing = true
	add_child(tween)
	tween.interpolate_property($static , "volume_db", - 80.0, - 20.0, 8.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$music.playing = true
	tween.interpolate_property($music, "volume_db", - 80.0, - 4.0, 8.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	cam.darken_with_set_values(1.0, 0.0, 2.0)

var ex = 0.0

func _process(delta):
	
	if stage2 == true: _handle_name_set()
	
	if stage1 == true:
		_append_letters()
		_check_input_movement()
	

func _check_input_movement():
	keys.get_child(row).get_child(column).modulate = Color(1, 1, 1, 1)
	
	if Input.is_action_just_pressed("ui_down"): row += 1
	if Input.is_action_just_pressed("ui_up"): row -= 1
	if row < 0: row = 0
	if row > 8: row = 8
	
	if Input.is_action_just_pressed("ui_right"): column += 1
	if Input.is_action_just_pressed("ui_left"): column -= 1
	
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		$movement.play()
	
	if row == 3 or row == 7:
		if column > 4: column = 4
	if row == 8:
		if column > 1: column = 1
	else: if column > 6: column = 6
	if column < 0: column = 0
	
	keys.get_child(row).get_child(column).modulate = Color(1, 1, 0, 1)
	
	tween.interpolate_property(
		soul, "position", 
		soul.position, keys.get_child(row).get_child(column).rect_position + Vector2(0, keys.get_child(row).position.y - 15), 0.5, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()

func _append_letters():
	if Input.is_action_just_pressed("ui_accept"):
		if row < 8 and playerName.text.length() < 6:
			nameStr = nameStr + keys.get_child(row).get_child(column).bbcode_text
			playerName.text = nameStr
			$select.play()
		
		if row == 8:
			if column == 0:
				nameStr.erase(nameStr.length() - 1, 1)
				playerName.text = nameStr
			if column == 1:
				stage2 = true
				stage1 = false
				
				_easter_egg_names()
				
				tween.interpolate_property(
					playerName, "rect_scale", 
					playerName.rect_scale, Vector2(2, 2), 1.5, 
					Tween.TRANS_QUINT, Tween.EASE_OUT
				)
				tween.interpolate_property(
					keys, "modulate:a", 
					1.0, 0.0, 1.2, 
					Tween.TRANS_QUINT, Tween.EASE_OUT
				)
				tween.interpolate_property(
					soul, "modulate:a", 
					1.0, 0.0, 2.0, 
					Tween.TRANS_QUINT, Tween.EASE_OUT
				)
				tween.start()

func _handle_name_set():
	
	if Input.is_action_just_pressed("ui_cancel"):
		$mug.hide()
		$mug.stop()
		$eskull.hide()
		$eskull.stop()
		$eggy.hide()
		$eggy.stop()
		$Images.hide()
		$vorprize.hide()
		title.text = "Предложите ей имя."
		stage2 = false
		stage1 = true
		
		tween.interpolate_property(
			playerName, "rect_scale", 
			playerName.rect_scale, Vector2(1, 1), 1.5, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		tween.interpolate_property(
			keys, "modulate:a", 
			0.0, 1.0, 1.2, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		tween.interpolate_property(
			soul, "modulate:a", 
			0.0, 1.0, 2.0, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		tween.start()
	
	if Input.is_action_just_pressed("ui_accept"):
		PlayerData.Name = playerName.text
		PlayerData._save_game()
	
		stage2 = false
		if trueName == true:
			tween.interpolate_property($music, "volume_db", - 4.0, - 80.0, 5.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
			trueName = false
			cam._resize_cam_out(cam.position, Vector2(0.5, 0.5), 2.5)
			cam.darken_with_set_values(0.0, 1.0, 2.5)
			
			yield(get_tree().create_timer(3.0), "timeout")
			
			get_tree().change_scene("res://Main Menu/MainMenu.tscn")
		elif playerName.text != "":
			_handle_postname_scene()
		if playerName.text == "": stage2 = true

func _handle_postname_scene():
	tween.interpolate_property($music, "volume_db", - 4.0, - 80.0, 8.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	title.text = ""
	$Images.hide()
	$mug.hide()
	$mug.stop()
	$eskull.hide()
	$eskull.stop()
	$eggy.hide()
	$eggy.stop()
	playerName.hide()
	$vorprize.hide()
	
	cam.darken_with_set_values(0.0, 0.5, 1.0)
	yield(get_tree().create_timer(4.0), "timeout")
	title.percent_visible = 0.0
	title.text = "Необычный выбор."
	tween.interpolate_property(title, "percent_visible", 0.0, 1.0, len(title.text) * 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(4.0), "timeout")
	title.text = ""
	yield(get_tree().create_timer(4.0), "timeout")
	title.percent_visible = 0.0
	title.text = "Однако, ты не можешь контролировать судьбу этого мира."
	tween.interpolate_property(title, "percent_visible", 0.0, 1.0, len(title.text) * 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(5.0), "timeout")
	title.text = ""
	yield(get_tree().create_timer(5.0), "timeout")
	
	title.percent_visible = 0.0
	title.text = "Твоя судьба уже написана."
	tween.interpolate_property(title, "percent_visible", 0.0, 1.0, len(title.text) * 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	move_child($Title, $Camera.get_position_in_parent() + 1)
	cam.darken_with_set_values(1.0, 1.0, 1.0)
	$static .volume_db = - 100
	
	yield(get_tree().create_timer(8.0), "timeout")
	
	title.hide()
	
	yield(get_tree().create_timer(3.0), "timeout")
	PlayerData.Name = playerName.text
	get_tree().change_scene("res://Cutscenes/misc/Instructions.tscn")


func _easter_egg_names():
	match nameStr.to_lower():
		"finger": title.text = "ребенок по имени палец:"
		"karax": title.text = "нужно больше соларита"
		"merg": title.text = "вишняя"
		"vor":
			title.text = "ты, наверное, знаешь, что оно делает"
			$vorprize.show()
		"": title.text = "как"
		"aaaaaa": title.text = "почему"
		"bbbbbb": title.text = "для этого есть ещё экземпляр"
		"obama":
			title.text = ""
			$Images.frame = 1
			$Images.show()
		"frisk": title.text = "..."
		"chara": title.text = "Она не отвечает на ваше предложение."
		"chione":
			title.text = "Истинное имя."
			trueName = true
		
		"toriel": title.text = "..."
		"asgore":
			title.text = "..."
			$Images.frame = 0
			$Images.show()
		"flowey": title.bbcode_enabled = "..."
		"asriel": title.text = "..."
		"papyru": title.text = "..."
		"undyne": title.text = "..."
		"sans": title.text = "..."
		"riverp": title.text = "бесплатный хостинг серверов"
		"alphys": title.text = "..."
		"metta", "mtt": title.text = "..."
		"gaster": title.text = "нет."
		"archon": title.text = "..."
		
		"zuphra", "zuph", "lucana", "luc": title.text = "зависимость от энергетика"
		"mugger":
			title.text = " "
			$mug.show()
			$mug.play()
		"kekuus": title.text = "доставка самодельной бомбы"
		"bloodm", "evanen":
			$eskull.show()
			$eskull.play()
		"spice", "spicii":
			$spices_dusttale.play()
			$spices_dusttale.show()
			title.text = ""
			stage2 = false
			yield(get_tree().create_timer(15.0), "timeout")
			
			OS.kill(OS.get_process_id())
		"eggy":
			title.text = "пасхальное яйцо"
			$eggy.show()
			$eggy.play()
		"epic": title.text = "!!"
		
	match nameStr:
		"b": title.text = "!"
