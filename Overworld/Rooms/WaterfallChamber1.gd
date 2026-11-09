extends Node2D

var canTrans = true

onready var camera = $Camera
onready var chione = $YSort / ChionePlayer
onready var textbox = $TextBox
onready var trans = $TransitionScreen
onready var transBox = $TransitionScreen / ColorRect
onready var transSoul = $TransitionScreen / Soul

onready var sans = $YSort / Sans_Waterfall
var tween = Tween.new()

var isInBattleMode = false

func _ready():
	OS.set("rendering/2d/snapping/use_gpu_pixel_snap", true)
	trans.set_process(false)
	add_child(tween)
	$music.playing = true
	
	PlayerData.items = ["Цвет. венок", "Спагетти", "Кусок снега", "Пирог"]
	PlayerData.finishedAreas[0] = true
	PlayerData.currentArea = "res://Overworld/Rooms/WaterfallChamber1.tscn"
	PlayerData._save_game()
	
	if PlayerData.madePastWaterfallIntro: chione.position = Vector2(240, 335)
	else:
		chione.position = Vector2( - 2750, 147)
		$wind.playing = true
		canPlayStepSound = true
	
	
	camera.darken_with_set_values(1.0, 0.4, 2.5)
	tween.interpolate_property(camera.get_child(0), "modulate:a", 0.0, 0.6, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	
	
	if PlayerData.madePastWaterfallIntro:
		camera._castNameplate("Пустые водопады", "Водопадье - Внешний сегмент\nМузыку сделал: Epic")
		$Particles2D.amount = 2500
		$music.volume_db = 0
	else: $music.playing = false
	RichPresence._update_activity("Waterfall - Outer Segment", "Desolate falls.")
	
	
	if PlayerData.WaterfallDeath:
		chione.position = Vector2(1180, - 560)
		$YSort / ChionePlayer / AnimatedSprite.animation = "down"
	
	camera.position = chione.position
	
	if not PlayerData.addParticles:
		$Particles2D2.amount /= 6
		$Particles2D.amount = 400
	
	if not PlayerData.addLights:
		$lights / Light2D2.energy = 0.0
		$lights / Light2D6.energy = 0.0
		$lights / Light2D7.energy = 0.0
	
var canMoveCamera = true

func _process(delta):
	
	
	
	if canMoveCamera:
		if camera.position.x < - 2470: camera.position.x = - 2470
		trans.position = camera.position - Vector2(320, 240)
		tween.interpolate_property(camera, "position", camera.position, chione.position, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
	
	textbox.rect_position.x = camera.position.x - 320
	textbox.rect_position.y = camera.position.y + 60
	$Particles2D.position.x = camera.position.x
	$Particles2D.position.y = camera.position.y - 300
	
	
	_collide_and_display()
	
	if PlayerData.madePastWaterfallIntro == false: _first_time_cutscene()
	if isInBattleMode:
		tween.interpolate_property(
			$Camera.get_child(0), "modulate:a", 
			$Camera.get_child(0).modulate.a, $Camera.get_child(0).modulate.a + 0.008 * (20 - chione.hp), 0.5, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()




var thirdTimeSlowdown = true

var isAfterIntro = 2
var canPlayStepSound = false

func _first_time_cutscene():
	
	if canPlayStepSound:
		if $YSort / ChionePlayer / AnimatedSprite.frame == 0 and $initsound / step1.playing == false:
			$initsound / step1.playing = true
			$initsound / step2.playing = false
		if $YSort / ChionePlayer / AnimatedSprite.frame == 2 and $initsound / step2.playing == false:
			$initsound / step2.playing = true
			$initsound / step1.playing = false
	
	if chione.position.x >= - 960 and thirdTimeSlowdown:
		canPlayStepSound = false
		thirdTimeSlowdown = false
		chione.speedgen = 4.0
		chione.canMove = false
		
		chione.get_child(0).animation = "falling"
		chione.get_child(0).frame = 1
		chione._play_hitminor()
		_shakeobj(chione)
		yield(get_tree().create_timer(0.9, false), "timeout")
		
		chione._play_hitminor()
		_shakeobj(chione)
		yield(get_tree().create_timer(2.0, false), "timeout")
		
		chione.get_child(0).frame = 2
		chione._play_hitminor()
		_shakeobj(chione)
		yield(get_tree().create_timer(0.9, false), "timeout")
		chione._play_hitminor()
		_shakeobj(chione)
		
		yield(get_tree().create_timer(2.4, false), "timeout")
		chione.get_child(0).frame = 0
		chione._play_hitminor()
		_shakeobj(chione)
		
		camera.darken_with_set_values(0.6, 1.0, 5.0)
		tween.interpolate_property(camera.get_child(0), "modulate:a", camera.get_child(0).modulate.a, 0.0, 5.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		
		
		yield(get_tree().create_timer(5.0, false), "timeout")
		chione.position = Vector2(240, 335)
		
		yield(get_tree().create_timer(2.0, false), "timeout")
		camera.darken_with_set_values(1.0, 0.6, 4.0)
		tween.interpolate_property(camera.get_child(0), "modulate:a", 0.0, 0.6, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property($wind, "volume_db", 0, - 80, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		
		
		yield(get_tree().create_timer(2.5, false), "timeout")
		chione.get_child(0).frame = 2
		chione._play_hitminor()
		_shakeobj(chione)
		
		yield(get_tree().create_timer(1.2, false), "timeout")
		chione.get_child(0).frame = 1
		chione._play_fall()
		_shakeobj(chione)
		
		yield(get_tree().create_timer(2.0, false), "timeout")
		isAfterIntro = 1
		
		
		$music.playing = true
		tween.interpolate_property($music, "volume_db", - 80.0, 0.0, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		chione.get_child(0).speed_scale = 1.0
		camera._castNameplate("Пустые водопады", "Водопадье - Внешний сегмент\nМузыку сделал: Epic")
		
		PlayerData.madePastWaterfallIntro = true
		PlayerData.finishedAreas[0] = true
		PlayerData._save_game()
		
		


var isSans = false
var canTransToOtherworld = true


func _collide_and_display():
	var collider
	if $YSort / EchoFlowerDead_1 / Area2D.get_overlapping_areas():
		collider = $YSort / EchoFlowerDead_1
		_show_box_text(collider)
	
	if $YSort / EchoFlowerDead_2 / Area2D.get_overlapping_areas():
		collider = $YSort / EchoFlowerDead_2
		_show_box_text(collider)
	
	if $YSort / Sans_Waterfall / Area2D.get_overlapping_areas():
		collider = sans
		_show_box_text(collider)
	
	if $mirror / Area2D.get_overlapping_areas():
		collider = $mirror
		_show_box_text(collider)
		
	
	if textbox.isActive:
		$YSort / ChionePlayer / AnimatedSprite.frame = 1
		$YSort / ChionePlayer / AnimatedSprite.playing = false
	
	
	
	
	if $Ground / Area2D.monitoring and $Ground / Area2D.get_overlapping_areas():
		_fallsequence()
		$Ground / Area2D.monitoring = false
	
	if isAfterIntro < 2:
		collider = $OtherChat / AwakeTextWaterfall
		_show_box_text(collider)


func _show_box_text(collider):
	
	if collider == sans and not textbox.isActive and not isSans:
		isSans = true
		
		textbox._create_box(collider.blitter, 0, collider.expr, collider.exprFrame, isSans)
		tween.interpolate_property($music, "volume_db", 0.0, - 80.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		chione._react(0)
		chione.canMove = false
		chione.find_node("AnimatedSprite").frame = 1
		chione.find_node("AnimatedSprite").playing = false
		_camMove()
	
	if Input.is_action_just_pressed("ui_accept") or isAfterIntro == 1:
		
		if textbox.isActive == false:
			chione.canMove = false
		
		if isAfterIntro == 1: isAfterIntro = 0
		textbox.maxIndex = collider.lineIndex
		if textbox.isActive == true:
			textbox.currentIndex += 1
			if textbox.currentIndex <= textbox.maxIndex:
				textbox._create_text(collider.blitter, textbox.currentIndex, collider.expr, collider.exprFrame)
			else:
				textbox._remove_box()
				
				chione.canMove = true
				isAfterIntro = 3
				if collider == sans:
					_start_battle()
					$YSort / Sans_Waterfall / Area2D.monitorable = false
					$YSort / Sans_Waterfall / Area2D.monitoring = false
					chione.canMove = false
				
				
				
		elif textbox.isActive == false:
			chione._react(1)
			chione.canMove = false
			var isSans = false
			if collider == sans: isSans = true
			textbox._create_box(collider.blitter, 0, collider.expr, collider.exprFrame, isSans)


func _camMove():
	yield(get_tree().create_timer(0.5, false), "timeout")
	tween.interpolate_property(camera, "position:y", camera.position.y, camera.position.y - 80, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()

func _fallsequence():
	$initsound.play()
	tween.interpolate_property(chione, "position:y", chione.position.y, 500, 0.72, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(chione, "position:x", chione.position.x, chione.position.x, 1.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	chione.canMove = false
	chione.get_node("AnimatedSprite").frame = 0
	chione.get_node("AnimatedSprite").animation = "slidefall"
	chione.get_node("AnimatedSprite").playing = false
	$YSort / ChionePlayer / Particles2D.emitting = true
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	
	
	

	
	camera.darken_with_set_values(0.4, 0.6, 1.5)
	chione.speedgen = 2.0
	$YSort / ChionePlayer / Particles2D.emitting = false
	
	
	
	chione.canMove = true
	chione.get_node("AnimatedSprite").frame = 1
	chione.get_node("AnimatedSprite").animation = "down"


func _start_battle():
	if canTrans:
		tween.interpolate_property($Camera / Sprite, "modulate:a", 1.0, 0.0, 0.6, Tween.TRANS_QUINT, Tween.TRANS_LINEAR)
		tween.start()
		trans._boot()
		canTrans = false
		
		trans.scene_change = "res://Cutscenes/Cutscene_BattleWaterfall.tscn"

func _on_ChionePlayer_enterBattleMode():
	camera.darken_with_set_values(0.6, 0.8, 3.0)
	isInBattleMode = true

func _shakeobj(object):
	for i in 6.0:
		if i % 2 == 0: object.position.x += (5.0 - i) * 1.2
		else: object.position.x -= (5.0 - i) * 1.2
		yield(get_tree().create_timer(0.07, false), "timeout")

onready var mirror = $mirror

func _archonOtherworldSetUp():
	tween.interpolate_property($BG, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Water, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Bridges, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Ground, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Effects, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($YSort / Decos, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Particles2D, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Particles2D2, "modulate:a", 1.0, 0.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Camera / Sprite, "modulate:a", 1.0, 0.0, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($CanvasModulate, "color", $CanvasModulate.modulate, Color(1, 1, 1), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($music, "volume_db", 0, - 80, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(chione, "global_position", chione.global_position, camera.global_position + Vector2(0, 80), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(mirror, "global_position", mirror.global_position, camera.global_position + Vector2(0, - 100), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	chione.canMove = false
	canMoveCamera = false
	chione.find_node("AnimatedSprite").animation = "up"
	chione.find_node("AnimatedSprite").frame = 1
	
	yield(get_tree().create_timer(2.0, false), "timeout")
	tween.interpolate_property(mirror, "modulate:a", 1.0, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	tween.start()
	chione.find_node("AnimatedSprite").animation = "runUp"
	chione.find_node("AnimatedSprite").frame = 0
	chione.find_node("AnimatedSprite").playing = true
	tween.interpolate_property(chione, "global_position", chione.global_position, camera.global_position + Vector2(0, - 50), 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	camera.darken_with_set_values(0.4, 1.0, 0.6)
	yield(get_tree().create_timer(0.6, false), "timeout")
	
