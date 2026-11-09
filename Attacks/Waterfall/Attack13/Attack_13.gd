extends Node2D

onready var main = get_node("/root/Battle_Engine")
onready var blasterNode = get_node("/root/Battle_Engine/BlasterNode")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var dialog = get_node("/root/Battle_Engine/Dialogue_Manager")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var sanssprite = get_node("/root/Battle_Engine/Battle_Sprites/Sans")
onready var floweysprite = get_node("/root/Battle_Engine/Battle_Sprites/Flowey")
onready var soul = get_node("/root/Battle_Engine/Player_Soul")
onready var splines = get_node("/root/Battle_Engine/SpeedLines")

var light1
var light2
var light3

var bone = preload("res://Bullets/Bone/Bone.tscn")


var blaster = preload("res://Bullets/Blaster/Blaster.tscn")

var boneblast = preload("res://Bullets/BoneBlast/BoneBlast.tscn")

var pelletcircle = preload("res://Bullets/PelletCircle/PelletCircle.tscn")
var flytrap = preload("res://Bullets/Flytrap/Flytrap.tscn")
var nuke = preload("res://Bullets/FloweyBomb/FloweyNuke.tscn")
var warn = preload("res://Bullets/Warn/Warn.tscn")
var arrow = preload("res://Bullets/Arrow/Arrow.tscn")

var bullet
var blast
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false
var is_blue_right = false
var is_blue_left = false
var is_gravity_affecting = false

func _ready():
	light1 = main.find_node("Gradient").find_node("Light2D6")
	light2 = main.find_node("Gradient").find_node("Light2D7")
	light3 = main.find_node("Gradient").find_node("ColorRect")

	add_child(tween)
	box_main._box_retween(220, 150, box_arena.rect_position.x - 10, box_arena.rect_position.y, 1.0)
	_attack()

var can_lookat = false

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true: soul._blue_down()
	if is_blue_up == true: soul._blue_up()
	if is_blue_right == true: soul._blue_right()
	if is_blue_left == true: soul._blue_left()
	
	if is_gravity_affecting: soul.slam_multiplier = 1.6
	if can_lookat == true:
		blast.look_at(soul.position)
		blast.rotation_degrees -= 90
		yield(get_tree().create_timer(0.3, false), "timeout")
		can_lookat = false

func _attack():
	bullet = arrow.instance()
	add_child(bullet)
	bullet._cast_arrow(Vector2(110, 75), 0)
	camera._resize_cam_out(Vector2(320, 280), Vector2(0.8, 0.8), 1.0)
	tween.interpolate_property(camera, "rotation_degrees", 0.0, - 7.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	camera.darken_with_set_values(0.0, 0.7, 1.0)
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 1.5)
	tween.interpolate_property(camera, "rotation_degrees", - 7.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	camera.darken_with_set_values(0.7, 0, 1.0)
	
	soul.slam_multiplier = 5.0
	sanssprite._slamDown()
	is_blue_down = true
	is_red = false
	yield(get_tree().create_timer(0.01, false), "timeout")
	
	
	tween.interpolate_property(box_arena, "rect_rotation", 0.0, 5.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.22, false), "timeout")
	bullet = arrow.instance()
	add_child(bullet)
	bullet._cast_arrow(Vector2(110, 75), 180)
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2( - 10, 150), Vector2(0, 0), Vector2(10, 55), 0.8, 5.8, "right", 220)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(230, 150), Vector2(0, 0), Vector2(10, 55), 0.8, 5.8, "left", 0)
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	bullet = boneblast.instance()
	main.add_child(bullet)
	bullet._cast_boneblast(Vector2(320, 100), 4)
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	soul.slam_multiplier = 5.0
	sanssprite._slamUp()
	is_blue_up = true
	is_blue_down = false
	yield(get_tree().create_timer(0.12, false), "timeout")
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 55), 0.8, 5.8, "right", 220)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(230, 0), Vector2(0, 0), Vector2(10, 55), 0.8, 5.8, "left", 0)
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	for i in 2:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(260, 150), Vector2(0, 0), Vector2(10, 80), 0.7, 6.0, "left", 0)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.35, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet._blue()
	bullet._cast_bullet(Vector2( - 10, - 20), Vector2(0, 0), Vector2(10, 220), 0.5, 0, "right", 220)
	tween.interpolate_property(bullet, "rotation_degrees", 0.0, - 100.0, 1.8, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 25), 0.8, 5.7, "right", 220)
	bullet = bone.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(230, 0), Vector2(0, 0), Vector2(10, 25), 0.8, 5.7, "left", 0)
	
	yield(get_tree().create_timer(0.45, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(220, 150), Vector2(0, 0), Vector2(10, 150), 0.0, 1.0, "left", 0)
	
	tween.interpolate_property(box_arena, "rect_rotation", 5.0, - 5.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	for i in 7:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 20, 0), Vector2(0, 0), Vector2(10, 20), 0.6, 5.0, "right", 220)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2( - 20, 150), Vector2(0, 0), Vector2(10, 95), 0.6, 5.0, "right", 220)
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	box_main._box_flash(2.0)
	_remove_assets()
	tween.interpolate_property(box_arena, "rect_rotation", 5.0, 0.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	camera._cam_beat(0.1)
	box_main._box_retween(150, 150, box_arena.rect_position.x - 150, box_arena.rect_position.y, 0.7)
	is_blue_up = false
	is_blue_right = true
	sanssprite._slamLeft()
	yield(get_tree().create_timer(0.7, false), "timeout")
	tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x + 180, 5.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()
	
	for i in 28:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(45, 10), 0.6, 4.5, "down", 160)
		
		if i % 9 == 0:
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.x = - 1
			bullet._cast_bullet(Vector2(150, 0), Vector2(0, 0), Vector2(25, 0), 0.8, 5.0, "down", 160)
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.x = - 1
			bullet._cast_bullet(Vector2(150, 150), Vector2(0, 0), Vector2(25, 0), 0.8, 5.0, "up", - 10)
		
		if i == 2:
			bullet = arrow.instance()
			main.add_child(bullet)
			bullet._cast_arrow(Vector2(320, 300), - 90)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	is_blue_right = false
	is_red = true
	camera.darken_with_set_values(0.0, 0.5, 3.6)
	var circle
	for i in 3:
		circle = pelletcircle.instance()
		main.add_child(circle)
		circle.position = Vector2(320, 300)
		var x = rand_range(0, 360)
		circle._cast_holeCircle(150, 6.0, "normal", x, x + 120, 2.0)
		yield(get_tree().create_timer(0.93, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet._orange()
	bullet._cast_bullet(Vector2(72, 0), Vector2(0, 0), Vector2(10, 10), 0.1, 0.0, "right", 300)
	tween.interpolate_property(bullet.get_child(0), "rect_size:y", 10, 150, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	
	splines.restart()
	splines.emitting = true
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	circle.queue_free()
	
	light1.hide()
	light2.hide()
	light3.hide()
	tween.interpolate_property(camera, "zoom", Vector2(0.4, 0.4), Vector2(1, 1), 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	camera.add_trauma(0.5)
	camera._cam_beat(0.12)
	tween.interpolate_property(camera, "rotation_degrees", 6.0, 0.0, 4.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	_remove_assets()
	
	camera.flash(2.0)
	
	_part_2()
	

func _part_2():
	is_blue_up = true
	is_red = false
	soul.slam_multiplier = 5.0
	sanssprite._slamUp()
	
	tween.interpolate_property(box_arena, "rect_position:y", box_arena.rect_position.y, box_arena.rect_position.y - 1150, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(box_arena, "rect_rotation", 0.0, 360, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(camera, "position:y", 240, - 800, 3.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(OS, "window_position:y", OS.window_position.y, OS.window_position.y - 80, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	tween.interpolate_property(camera.find_node("Particles2D"), "modulate:a", 2.0, 0.0, 13.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(1.0, false), "timeout")
	splines.emitting = false
	yield(get_tree().create_timer(0.2, false), "timeout")
	box_arena.rect_rotation = 0.0
	soul.slam_multiplier = 5.0
	
	bullet = arrow.instance()
	main.add_child(bullet)
	bullet._cast_arrow(Vector2(320, - 900), 0)
	
	for i in 3:
		bullet = bone.instance()
		main.add_child(bullet)
		bullet.position.x = soul.position.x
		tween.interpolate_property(bullet.get_child(0), "rect_size:y", 10, 45, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(bullet, "position:y", - 1000, soul.position.y + 1500, 1.6, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(0.4, false), "timeout")
	
	for i in 6:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 20, 0), Vector2(0, 0), Vector2(10, 40), 0.1, 7.0, "right", 150)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(170, 0), Vector2(0, 0), Vector2(10, 40), 0.1, 7.0, "left", 0)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	sanssprite._reposition()
	is_blue_up = false
	is_blue_down = true
	soul.slam_multiplier = 5.0
	
	light1.show()
	light2.show()
	light3.show()
	
	var ft = flytrap.instance()
	var ft1 = flytrap.instance()
	main.add_child(ft)
	main.add_child(ft1)
	main.move_child(ft, 9)
	main.move_child(ft1, 9)
	
	$Sparkle.play()
	ft.position.x = 0
	ft.rotation_degrees = - 35
	ft.scale = Vector2(1.2, 1.2)
	ft1.position.x = 640
	
	ft1.rotation_degrees = 35
	ft1.scale = Vector2( - 1.2, 1.2)
	tween.interpolate_property(ft, "position:y", - 400, - 520, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(ft1, "position:y", - 400, - 520, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	_lightBeat()
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	ft._cast_fly(50)
	ft1._cast_fly(50)
	camera._resize_cam_out(Vector2(320, - 740), Vector2(0.88, 0.88), 1.0)
	
	box_main._box_retween(640, 480, box_arena.rect_position.x - 250, box_arena.rect_position.y - 60, 1.0)
	is_blue_down = false
	is_red = true
	
	var bomb = nuke.instance()
	for i in 9:
		bullet = pelletcircle.instance()
		main.add_child(bullet)
		bullet.position = soul.position
		bullet._cast_dodgeCircle(95, 8.0, "normal", 0.06, 0.15)
		bullet.rotation_degrees = rand_range(0, 180)
		main.move_child(bullet, 9)
		if i % 3 == 0 and i != 9:
			bullet = pelletcircle.instance()
			main.add_child(bullet)
			bullet.position = soul.position
			bullet._cast_circle(200, 14.0, "orange", 0.05, 0.15)
			main.move_child(bullet, 9)
		if i == 3:
			camera._cam_beat(0.1)
			main.add_child(bomb)
			bomb.get_child(1).play()
			camera.add_trauma(1.0)
			bomb.position.x = 320
			bomb.position.y = - 1400
			_rumble()
			bomb.scale = Vector2(6, 6)
			
			var n = warn.instance()
			main.add_child(n)
			n._cast(Vector2(320, - 850))
			
			tween.interpolate_property(bomb, "position:y", - 1400, - 1000, 6.8, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.interpolate_property(OS, "window_position:y", OS.window_position.y, OS.window_position.y + 80, 6.8, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
		yield(get_tree().create_timer(1.0, false), "timeout")
	
	camera._remove_tweens()
	camera._flash_dark(0.5)
	_remove_assets()
	ft.queue_free()
	ft1.queue_free()
	bomb.queue_free()
	
	soul.hp += 5
	
	camera._resize_cam_out(Vector2(320, 300), Vector2(0.1, 0.1), 0.2)
	
	box_main._box_retween(240, 150, box_arena.rect_position.x + 210, box_arena.rect_position.y + 1210, 0.8)
	
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	sanssprite.get_child(5).frame = 1
	floweysprite.get_child(1).frame = 1
	floweysprite.position.x += 75
	sanssprite.position.x += 65
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 5.0)
	camera.darken_with_set_values(1.0, 0.0, 1.0)
	
	soul.position = Vector2(320, 240)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(240, 150), Vector2(0, 0), Vector2(10, 80), 0.8, 4.8, "left", - 10)
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in 4:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 25), 0.6, 4.7, "right", 250)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 60 + i * 10), 0.6, 4.7, "right", 250)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet._blue()
	bullet._cast_bullet(Vector2(0, - 10), Vector2(0, 0), Vector2(240, 10), 0.1, 4.6, "down", 160)
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	for i in 24.0:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 45 + sin(i / 2.0) * 30), 1.0, 5.4, "right", 250)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 45 - sin(i / 2.0) * 30), 1.0, 5.4, "right", 250)
		if i % 5 == 0 and i > 0:
			bullet = blaster.instance()
			main.add_child(bullet)
			bullet._cast_blaster(soul.position.x, - 100, soul.position.x, 200, - 30, 0, 1.2, 20)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	box_main._box_retween(150, 150, box_arena.rect_position.x + 45, box_arena.rect_position.y, 1.0)
	camera._resize_cam_out(Vector2(320, 280), Vector2(0.85, 0.85), 1.0)
	_spawn_blasters()
	


func _rumble():
	for i in 65:
		camera.add_trauma(0.2)
		yield(get_tree().create_timer(0.1, false), "timeout")

func _lightBeat():
	for i in 10:
		if PlayerData.addLights: tween.interpolate_property(camera.find_node("Light2D"), "energy", 1.0, 0.0, 0.9, Tween.TRANS_QUINT, Tween.EASE_IN)
		if PlayerData.addParticles:
			tween.interpolate_property(camera.find_node("Particles2D"), "modulate:a", 2.0, 0.0, 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
			camera.find_node("Particles2D").emitting = true
		
		tween.start()
		yield(get_tree().create_timer(1, false), "timeout")
	camera.find_node("Particles2D").emitting = false

var value = 0.0
var waittime = 0.08

func _spawn_blasters():
	sanssprite.get_child(5).frame = 0
	for i in 30:
		blast = blaster.instance()
		main.add_child(blast)
		var pos_x = cos(value) * 150
		var pos_y = sin(value) * 150
		value -= 0.32
		
		var startX = 0.0
		if cos(value) < 0: startX = - 100
		else: startX = 740
		
		var startY = 0.0
		if sin(value) < 0: startY = 580
		else: startY = - 100
		blast._cast_blaster_without_rotation(Vector2(cos(value) * 800, sin(value) * 800), Vector2(pos_x + 320, pos_y + 300), 1.2, 30)
		blast.look_at(box_arena.rect_position)
		blast.rotation_degrees -= 71
		yield(get_tree().create_timer(waittime, false), "timeout")
	
	yield(get_tree().create_timer(1.3, false), "timeout")
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 1.0)
	PlayerData.finishedAreas[1] = true
	PlayerData._save_game()
	
	
	
	box_main._box_retween(30, 30, box_arena.rect_position.x + 60, box_arena.rect_position.y + 60, 1.0)
	yield(get_tree().create_timer(0.8, false), "timeout")
	
	dialog._cast_dialogue_inbattle("Не возвращайся.")
	dialog.rect_position.x += 80
	$appear.play()
	var bullet1 = bone.instance()
	main.add_child(bullet1)
	bullet1.scale.x = - 1
	bullet1._cast_bullet(Vector2(100, soul.global_position.y - 10), Vector2(0, 0), Vector2(50, 10), 0.7, 0.0, "right", 500)
	
	var bullet2 = bone.instance()
	main.add_child(bullet2)
	bullet2._cast_bullet(Vector2(540, soul.global_position.y - 10), Vector2(0, 0), Vector2(50, 10), 0.7, 0.0, "left", 100)
	
	camera.darken_with_set_values(0.0, 0.8, 1.6)
	yield(get_tree().create_timer(1.0, false), "timeout")
	
	
	tween.interpolate_property(bullet1, "position:x", 100, 300, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.interpolate_property(bullet2, "position:x", 540, 340, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	
	bullet1.queue_free()
	bullet2.queue_free()
	$heavy.play()
	camera.add_trauma(0.8)
	camera.flash(7.0)
	camera.get_child(0).hide()
	
	dialog.hide()
	main._endFrame()
	yield(get_tree().create_timer(17.0, false), "timeout")
	PlayerData.finishedAreas[1] = true
	PlayerData._save_game()
	get_tree().change_scene("res://Cutscenes/WaterfallEnd_Sans.tscn")
	
func _remove_assets():
	for i in get_children():
		if i.get_index() > 5:
			self.remove_child(i)
