extends Node2D

onready var sans_standing = $Battle_Sprites / Sans
onready var sans_sitting = $Sans_sit
onready var sansHead = $Battle_Sprites / Sans / Sans_Head
onready var flowey = $Battle_Sprites / Flowey
onready var cam = $Camera
onready var blitter = $RichTextLabel

onready var font = preload("res://determination-mono-web-font/sans_font.tres")
var tween = Tween.new()
var text_tween = Tween.new()

var index = 0.0

func _ready():
	OS.set("rendering/2d/snapping/use_gpu_pixel_snap", false)
	$music.play()
	add_child(tween)
	add_child(text_tween)
	
	_cutscene()
	cam._blur(2.0, 0.5, 4.0)
	
	if not PlayerData.addParticles:
		$Rain2.amount /= 3
		$Particles2D.amount /= 4
	
	if not PlayerData.addLights:
		$Gradient / Light2D6.queue_free()
		$Gradient / Light2D7.queue_free()
	
	yield(get_tree().create_timer(20, false), "timeout")
	_light_below()
	


var indexanim = 1

func _process(delta):
	
	sans_sitting.scale.y += cos(index / 100) / 2800
	index += 1
	if text_tween.is_active():
		var pos = blitter.get_visible_characters()
		
		var getchar = blitter.text[blitter.visible_characters]
		if getchar != " " or getchar != "." or getchar != ",":
			$voice.play()
			$voice.pitch_scale = rand_range(0.98, 1.02)
	
	if Input.is_action_pressed("cutsceneskip"): get_tree().change_scene("res://Battle_Engine.tscn")

var text = [
	"...значит, ты чужеземка, да?", 
	"я уже встречал таких, как ты, раньше.", 
	"знаешь, есть одна из вещей, которая нас всех объединяет.", 
	"даже будучи совершенно незнакомыми, мы отражаемся друг в друге.", 
	"...не то чтобы это имело значение... но я должен кое-что спросить:", 
	"что привело тебя сюда? какие у тебя мотивы? какие намерения?", 
	"ты что-то или кого-то ищешь...?", 
	"...если это всё, то я не могу так просто пропустить тебя.", 
	"ты стремишься двигаться дальше, но не задаёшься вопросом: 'а что ждёт меня впереди?'.", 
	"поверь мне — некоторые вещи лучше оставить в прошлом."
]

func _cutscene():
	sans_sitting.show()
	sans_standing.hide()
	cam.darken_with_set_values(1.0, 0.0, 5.0)
	cam.zoom = Vector2(0.6, 0.6)
	cam._resize_cam_out(Vector2(320, 240), Vector2(1.0, 1.0), 6.0)
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	_add_blitter(text[0])
	
	yield(get_tree().create_timer(8.6, false), "timeout")
	
	_add_blitter(text[1])
	
	for i in 7:
		if i < 4:
			yield(get_tree().create_timer(4.6, false), "timeout")
		else: yield(get_tree().create_timer(2.3, false), "timeout")
		
		if i == 0: _add_blitter(text[2])
		if i == 1: _add_blitter(text[3])
		if i == 2:
			_add_blitter(text[4])
			sans_sitting.frame = 0
		if i == 3: _add_blitter(text[5])
		if i == 6: _add_blitter(text[6])
	
	yield(get_tree().create_timer(2.0, false), "timeout")
	cam.darken_with_set_values(0.0, 1.0, 2.0)
	
	cam._resize_cam_out(Vector2(320, 240), Vector2(0.8, 0.8), 2.5)
	yield(get_tree().create_timer(4.2, false), "timeout")
	cam.darken_with_set_values(1.0, 0.0, 4.0)
	
	cam._resize_cam_out(Vector2(320, 240), Vector2(1.0, 1.0), 4.5)
	tween.interpolate_property(cam, "rotation_degrees", 20.0, 0.0, 4.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	sans_sitting.frame = 1
	_add_blitter(text[7])
	
	yield(get_tree().create_timer(4.7, false), "timeout")
	_move_sprite(sans_sitting)
	_add_blitter(text[8])
	yield(get_tree().create_timer(1.6, false), "timeout")
	_move_sprite(sans_sitting)
	yield(get_tree().create_timer(1.6, false), "timeout")
	_move_sprite(sans_sitting)
	yield(get_tree().create_timer(1.5, false), "timeout")
	sans_sitting.hide()
	sans_standing.show()
	sans_standing._resizesquish()
	$Battle_Sprites / Sans / Sans_Head.frame = 1
	_add_blitter(text[9])
	_move_sprite(sans_standing)
	yield(get_tree().create_timer(1.8, false), "timeout")
	_move_sprite(sans_standing)
	$Battle_Sprites / Sans / Sans_Head.frame = 0
	yield(get_tree().create_timer(2.6, false), "timeout")
	cam._resize_cam_out(Vector2(310, 265), Vector2(0.4, 0.4), 3.0)
	cam.darken_with_set_values(0.0, 1.0, 0.5)
	tween.interpolate_property(cam, "rotation_degrees", 0.0, - 6.0, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	cam.add_trauma(0.5)
	sansHead.frame = 1
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	_scene_transition()

func _scene_transition():
	get_tree().change_scene("res://Battle_Engine.tscn")

func _add_blitter(text):
	blitter.bbcode_text = text
	blitter.percent_visible = 0.0
	text_tween.interpolate_property(
		blitter, "percent_visible", 
		0.0, 1.0, len(blitter.bbcode_text) * 0.04, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	text_tween.start()

func _light_below():
	$Particles2D.restart()
	$Particles2D.emitting = true
	cam._cam_beat(0.08)
	tween.interpolate_property($Gradient / Light2D2, "color:a", 1.0, 0.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _move_sprite(sprite):
	sprite.position.x += 5
	yield(get_tree().create_timer(0.07, false), "timeout")
	sprite.position.x += - 9
	yield(get_tree().create_timer(0.07, false), "timeout")
	sprite.position.x += 7
	yield(get_tree().create_timer(0.07, false), "timeout")
	sprite.position.x += - 5
	yield(get_tree().create_timer(0.07, false), "timeout")
	sprite.position.x += 3
	yield(get_tree().create_timer(0.07, false), "timeout")
	sprite.position.x += - 1
