extends Node2D


onready var chioneSprite = $Chione
onready var credits = $Credits
onready var light = $Light2D

onready var gametext = $Game_Over_Text / game
onready var overtext = $Game_Over_Text / over
onready var soul_frozen = $SoulFrozen

onready var soul = $SoulBreaks

onready var blitter = $Blitter
onready var crect = $ColorRect

var index = 0.0
var previndex = 0.0
var rect_fade_index = 0.0
var keypress_to_fade = false
var canKeypress = true

var texttween = Tween.new()


func _ready():
	add_child(texttween)
	$music.volume_db = - 80
	$Tween.interpolate_property($music, "volume_db", - 80.0, 0.0, 30, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$music.play()
	$Tween.start()
	soul.position = $Player_Soul.position
	blitter.percent_visible = 0.0
	keypress_to_fade = false
	index = 0.0
	rect_fade_index = 0.0
	
	chioneSprite.position = Vector2( - 100, 390)
	soul.position = Vector2(70, 440)
	
	credits.modulate.a = 0.0
	
	gametext.position = Vector2( - 150, 100)
	overtext.position = Vector2(840, 100)
	soul_frozen.position = Vector2(320, - 100)
	
	crect.modulate.a = 0.0
	crect.rect_size = Vector2(640, 480)
	
	$Gaster.modulate.a = 0.0
	
	RichPresence._update_activity("Rest for a while.", "Valentior Anima")
	_act()
	
	yield(get_tree().create_timer(35.0), "timeout")
	$Background / Particles2D.emitting = true


func _process(delta):
	index += delta * 40
	if texttween.is_active():
		var pos = blitter.get_visible_characters()
		if blitter.text.length() > pos and blitter.text[pos] != " ":
			$chatter_fx.play()
	
	_awaitInput()
	
	if cananimgaster: _anim_gaster()
	
func _act():
	$Tween.interpolate_property(soul, "position", SoulPositionSingleton.soulPosition, Vector2(320, 240), 1.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(soul, "scale", soul.scale, Vector2(3.0, 3.0), 1.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(1.3), "timeout")
	
	for i in 12:
		if i % 2 == 0: soul.position.x = 318
		else: soul.position.x = 322
		yield(get_tree().create_timer(0.04), "timeout")
		
	$Camera.add_trauma(0.6)
	soul.frame = 1
	$soulbreak_1_fx.play()
	$SoulBreaks / Particles2D.emitting = true
		
	yield(get_tree().create_timer(0.5), "timeout")
	$Tween.interpolate_property(soul, "position", soul.position, Vector2(320, 600), 1.4, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	
	
	yield(get_tree().create_timer(0.8), "timeout")
	$swipe_fx.play()
	$Tween.interpolate_property(chioneSprite, "position:x", chioneSprite.position.x, 320, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(light, "position:x", light.position.x, 320, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(0.6), "timeout")
	
	_background()
	$Tween.interpolate_property(gametext, "position:x", - 130, 200, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(overtext, "position:x", 740, 440, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(0.7), "timeout")
	$soul_fx.play()
	$Tween.interpolate_property(soul_frozen, "position:y", soul_frozen.position.y, soul_frozen.position.y + 300, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(soul_frozen, "modulate:a", 0.0, 0.55, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	_soulMov()
	
	yield(get_tree().create_timer(0.5), "timeout")
	var rand = int(rand_range(0, 2))
	if rand == 0: blitter.text = "УЖЕ СЛИШКОМ ПОЗДНО ОТСТУПАТЬ, ЧЕЛОВЕК!"
	if rand == 1: blitter.text = "ПОКАЖИ НАМ, НА ЧТО ТЫ СПОСОБНА! НЬЕХ-ХЕХ-ХЕ!!"
	
	texttween = Tween.new()
	add_child(texttween)
	texttween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.text) * 0.04, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	texttween.start()
	
	yield(self, "isInput")
	
	_transToScreen()

onready var gasterface = $Gaster / Face
onready var gasterbody = $Gaster / Body

func _soulMov():
	while 1:
		soul_frozen.position.y += cos(index / 33.0) / 30.0
		soul_frozen.modulate = Color(1.1, 1.1, 1.1, 0.9)
		soul_frozen.modulate.a += sin(index / 32.0) / 15.0
		yield(get_tree().create_timer(get_process_delta_time()), "timeout")

func _background():
	
	var path = $Background / Path
	var tree = $Background / tree
	var bench = $Background / bench
	var treeright = $Background / Treesright
	var treeleft = $Background / Treesleft
	var grad = $Background / grad
	_simpletween(path, 65)
	yield(get_tree().create_timer(0.6), "timeout")
	_simpletween(bench, - 45)
	yield(get_tree().create_timer(0.6), "timeout")
	_simpletween(tree, - 25)
	yield(get_tree().create_timer(0.6), "timeout")
	_simpletween(treeright, 45)
	_simpletween(treeleft, - 45)
	yield(get_tree().create_timer(0.6), "timeout")
	_simpletween(grad, 0)
	
	_gaster_time()


func _simpletween(node, pos):
	$Tween.interpolate_property(node, "position:x", node.position.x + pos, node.position.x, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(node, "modulate:a", 0.0, 1.0, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func _gaster_time():
	yield(get_tree().create_timer(300.0), "timeout")
	print(1)
	$Tween.interpolate_property($Gaster, "modulate:a", 0.0, 0.7, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	cananimgaster = true
	
func _transToScreen():
	$fuseSound.play()
	$Tween.interpolate_property($Camera, "zoom", $Camera.zoom, Vector2(0.3, 0.3), 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(soul_frozen, "position:y", soul_frozen.position.y, soul_frozen.position.y + 20, 1.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(crect, "modulate:a", crect.modulate.a, 1.5, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($music, "volume_db", $music.volume_db, - 35.0, 2.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(3.0), "timeout")
	_deathCheck()
	
	get_tree().change_scene(PlayerData.currentArea)

var cananimgaster = false

func _deathCheck():
	match PlayerData.currentArea:
		"res://Overworld/Rooms/Snowdin.tscn": PlayerData.SnowdinDeath = true
		"res://Overworld/Rooms/WaterfallChamber1.tscn": PlayerData.WaterfallDeath = true

func _anim_gaster():
	gasterface.position.y += cos(index / 30) * 3 / 44
	gasterbody.scale.y -= cos(index / 30) / 760

signal isInput

func _awaitInput():
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("isInput")
