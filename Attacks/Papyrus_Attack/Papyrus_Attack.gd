extends Node2D


onready var main = get_node("/root/Battle_Engine")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var papyrus_spr = get_node("/root/Battle_Engine/papyrus")
onready var soul = get_node("/root/Battle_Engine/Player_Soul")

onready var music = get_node("/root/Battle_Engine/music")
var bone_preload = preload("res://Bullets/Bone_Papyrus/BoneP.tscn")
var dog = preload("res://Bullets/Dog/Dog.tscn")
var blaster = preload("res://Bullets/BlasterPapyrus/Blaster.tscn")
var glasses = preload("res://Bullets/BlasterPapyrus/Glasses.tscn")

var index = 0.0
var bullet
var tween = Tween.new()
var node = Node2D.new()

var wallnode

func _ready():
	add_child(node)
	add_child(tween)
	wallnode = main.get_child(2)
	
	_attack()

var is_red = true
var is_blue_down = false
var is_blue_up = false

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()

func _attack():
	camera._resize_cam_out(Vector2(320, 240), Vector2(0.8, 0.8), 1.0)
	camera.darken_with_set_values(0.0, 1.0, 1.6)
	yield(get_tree().create_timer(2.0, false), "timeout")
	camera.zoom = Vector2(0.8, 0.8)
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 1.6)
	camera.darken_with_set_values(1.0, 0.0, 1.0)
	papyrus_spr.get_child(0)._change_head_spr(2)
	is_red = true
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2(0, 0), Vector2(0, 0), Vector2(10, 35 + i * 10), 
			1.5, 5.0, "right", 300
		)
		
		if i == 1:
			if bullet.global_position.x > 215: get_parent().rect_position.x -= bullet.global_position.x - 215
			if bullet.global_position.x < 215: get_parent().rect_position.x += 215 - bullet.global_position.x
		
		yield(get_tree().create_timer(0.1, false), "timeout")
	yield(get_tree().create_timer(0.25, false), "timeout")
	
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2(210, 150), Vector2(0, 0), Vector2(10, 55 + i * 10), 
			1.5, 5.0, "left", - 100
		)
		bullet.rotation_degrees = 180
		yield(get_tree().create_timer(0.1, false), "timeout")
	yield(get_tree().create_timer(0.04, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(
			Vector2(250, 160), Vector2(0, 0), Vector2(135, 10), 
			2.0, 0.0, "right", 300
		)
		tween.interpolate_property(
			bullet, "position:y", 
			160, - 140, 2.2, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
		
		yield(get_tree().create_timer(0.12, false), "timeout")
	yield(get_tree().create_timer(0.08, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(
		Vector2(0, 0), Vector2(0, 0), Vector2(85, 10), 
		3.0, 0.0, "left", - 100
	)
	tween.interpolate_property(
		bullet, "position:y", 
		0, 140, 1.0, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	
	tween.interpolate_property(
		bullet, "position:y", 
		140, - 140, 1.3, 
		Tween.TRANS_QUINT, Tween.EASE_IN
	)
	tween.start()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	is_red = false
	is_blue_down = true
	soul._blink()
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(5, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 4.5, "right", 300)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(205, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 4.5, "left", - 100)
		
		yield(get_tree().create_timer(0.4, false), "timeout")
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(15, 150), Vector2(0, 0), Vector2(10, 25), 1.2, 4.5, "right", 300)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(215, 150), Vector2(0, 0), Vector2(10, 25), 1.2, 4.5, "left", - 100)
		
		yield(get_tree().create_timer(0.35, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(5, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 4.5, "right", 300)
		
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(205, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 4.5, "left", - 100)
		
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(15, 150), Vector2(0, 0), Vector2(10, 45), 1.2, 3.5, "right", 300)
		
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(215, 150), Vector2(0, 0), Vector2(10, 45), 1.2, 3.5, "left", - 100)
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	
	is_blue_down = false
	is_blue_up = true
	soul._blink()
	
	yield(get_tree().create_timer(0.04, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(25, 0), Vector2(0, 0), Vector2(10, 150), 1.0, 0.0, "right", 320)
	bullet._blue()
	
	tween.interpolate_property(bullet, "position:x", bullet.position.x, bullet.position.x + 320, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(175, 0), Vector2(0, 0), Vector2(10, 150), 1.0, 0.0, "left", - 100)
	bullet._blue()
	
	tween.interpolate_property(bullet, "position:x", bullet.position.x, bullet.position.x - 300, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	
	box_main._box_flash(1.5)
	box_main._box_rotate_direct(360, 2.5)
	box_main._box_retween(230, 130, - 55, 30, 2.0)
	for i in get_children():
		if weakref(i).get_ref() and i.get_index() > 4:
			remove_child(i)
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 20), 1.0, 5.0, "right", 250)
		
		yield(get_tree().create_timer(0.15, false), "timeout")
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 70), 1.0, 5.0, "right", 250)
		
		yield(get_tree().create_timer(0.25, false), "timeout")
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 105), 2.0, 5.0, "right", 250)
		
		yield(get_tree().create_timer(0.25, false), "timeout")
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	is_blue_up = false
	is_blue_down = true
	soul._blink()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(230, 130), Vector2(0, 0), Vector2(10, 20), 1.0, 5.0, "left", - 15)
		
		yield(get_tree().create_timer(0.15, false), "timeout")
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(230, 0), Vector2(0, 0), Vector2(10, 70), 2.0, 5.0, "left", - 15)
		
		yield(get_tree().create_timer(0.25, false), "timeout")
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._blue()
		bullet._cast_bullet(Vector2(230, 130), Vector2(0, 0), Vector2(10, 105), 1.0, 5.0, "left", - 15)
		
		yield(get_tree().create_timer(0.25, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(0, 5), Vector2(0, 0), Vector2(10, 120), 1.0, 3.5, "right", 250)
	
	tween.interpolate_property(bullet, "position:y", bullet.position.y, bullet.position.y - 150, 1.4, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	
	
	
	tween.interpolate_property(camera, "position", camera.position, Vector2(320, 170), 1.3, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.interpolate_property(camera, "zoom", camera.zoom, Vector2(0.65, 0.65), 1.3, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	camera.darken_with_set_values(0.0, 0.6, 2.0)
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	
	
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	yield(get_tree().create_timer(0.27, false), "timeout")
	
	camera._resize_cam_out(Vector2(320, 240), Vector2(1.0, 1.0), 1.2)
	camera.flash(3.0)
	
	$sparkle.play()
	
	main.get_child(2).set_process(true)
	main.get_child(2).show()
	
	_attack_part_2()

func _attack_part_2():
	
	papyrus_spr._shake_to_battle()
	papyrus_spr.get_child(1)._change_head_spr(2)
	papyrus_spr.addition = 0.09
	box_main._box_retween(300, 130, - 80, 30, 1.2)
	is_red = true
	is_blue_down = false
	soul._blink()
	
	yield(get_tree().create_timer(0.08, false), "timeout")
	
	for i in 8:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 80), 1.3, 8, "right", 320)
		tween.interpolate_property(bullet, "rotation_degrees", 90, 0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(310, 0), Vector2(0, 0), Vector2(10, 80), 1.3, 8, "left", - 20)
		tween.interpolate_property(bullet, "rotation_degrees", - 90, 0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.06, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 25 + i * 7), 1.3, 4, "right", 320)
		tween.interpolate_property(bullet, "rotation_degrees", 90, 180, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(310, 130), Vector2(0, 0), Vector2(10, 25 + i * 7), 1.3, 4, "left", - 20)
		tween.interpolate_property(bullet, "rotation_degrees", 270, 180, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.06, false), "timeout")
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 55 + i * 5), 1.3, 4, "right", 320)
		tween.interpolate_property(bullet, "rotation_degrees", 90, 180, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(310, 130), Vector2(0, 0), Vector2(10, 55 + i * 5), 1.3, 4, "left", - 20)
		tween.interpolate_property(bullet, "rotation_degrees", 270, 180, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 25), 1.5, 6, "left", - 20)
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		bullet._cast_bullet(Vector2(40, 0), Vector2(0, 0), Vector2(10, 130), 1.2, 0, "right", 340)
		tween.interpolate_property(bullet, "position:x", 40, 350, 1.5, Tween.TRANS_BACK, Tween.EASE_IN)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(270, 130), Vector2(0, 0), Vector2(10, 130), 1.2, 0, "left", - 20)
		tween.interpolate_property(bullet, "position:x", 260, - 20, 1.5, Tween.TRANS_BACK, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(0.4, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(300, 0), Vector2(0, 0), Vector2(10, 55), 4.0, 4.6, "left", - 20)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 80), 4.0, 4.6, "right", 320)
		
		if i >= 1:
			bullet = bone_preload.instance()
			main.add_child(bullet)
			bullet._cast_bullet(Vector2(soul.position.x, 200), Vector2( - 10, 0), Vector2(10, 55), 2.5, 0.0, "right", 600)
			tween.interpolate_property(bullet, "position:y", 200, 700, 1.2, Tween.TRANS_BACK, Tween.EASE_IN)
			tween.start()
		yield(get_tree().create_timer(0.7, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	is_blue_down = true
	is_red = false
	soul._blink()
	
	box_main._box_retween(320, 130, - 80, 35, 1.0)
	for i in 3:
		if i == 1:
			for j in 3:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet.rotation_degrees = 180
				bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 80), 6.0, 3.7, "right", 340)
				yield(get_tree().create_timer(0.1, false), "timeout")
			yield(get_tree().create_timer(0.15, false), "timeout")
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2( - 30, 0), Vector2(0, 0), Vector2(10, 120), 8.0, 3.5, "right", 340)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(320, 130), Vector2(0, 0), Vector2(10, 20), 1.0, 5.5, "left", - 20)
		
		if i == 1:
			yield(get_tree().create_timer(0.2, false), "timeout")
		yield(get_tree().create_timer(0.55, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 70), 1.6, 6.5, "left", - 20)
	tween.interpolate_property(bullet, "rotation_degrees", - 90, 0, 1.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.15, false), "timeout")
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		if i % 2 == 0:
			bullet._cast_bullet(Vector2(210 + i * 10, 0), Vector2(0, 0), Vector2(10, 110), 1.8 + i * 4 / 10, 0.0, "left", - 20)
		else:
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(220 + i * 10, 130), Vector2(0, 0), Vector2(10, 110), 1.8 + i * 4 / 10, 0.0, "left", - 20)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, - 30, 1.8 + i * 1.5 / 10, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 60), 5.0, 5.0, "left", - 20)
		tween.interpolate_property(bullet, "rotation_degrees", - 30, 0, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(330, 130), Vector2(0, 0), Vector2(10, 60), 5.0, 5.0, "left", - 20)
		tween.interpolate_property(bullet, "rotation_degrees", 210, 180, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	yield(get_tree().create_timer(1.2, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 4.2, "right", 340)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(13, 130), Vector2(0, 0), Vector2(10, 40), 1.0, 4.2, "right", 340)
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(350, 130), Vector2(0, 0), Vector2(10, 80), 5.5, 4.0, "left", - 20)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 70), 5.5, 4.5, "right", 340)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.65, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 30), 6.5, 5.7, "right", 340)
		
		
		
		
		
		
		
		
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		if i % 2 == 0:
			bullet._cast_bullet(Vector2(30 - i * 10, 0), Vector2(0, 0), Vector2(10, 110), 1.8 - i * 4 / 10, 0.0, "right", 360)
		else:
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(40 - i * 10, 130), Vector2(0, 0), Vector2(10, 110), 1.8 - i * 4 / 10, 0.0, "right", 360)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, 390, 1.8 - i * 1.5 / 10, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2( - 40, 130), Vector2(0, 0), Vector2(10, 16), 1.0, 5.2, "right", 340)
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 75), 1.2, 6.5, "left", - 20)
		yield(get_tree().create_timer(0.4, false), "timeout")
	
	yield(get_tree().create_timer(0.07, false), "timeout")
	for i in 5:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(320, 130), Vector2(0, 0), Vector2(10, 90), 1.5, 3.2, "left", - 20)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	is_blue_down = false
	is_blue_up = true
	soul._blink()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in 1:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 25), 1.0, 4.5, "right", 340)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 3:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 130), 1.0, 3.8, "left", - 20)
		yield(get_tree().create_timer(0.1, false), "timeout")
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	for i in node.get_children():
		i._change_size(Vector2(10, 40), 1.0)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.75, false), "timeout")
	is_blue_down = true
	is_blue_up = false
	soul._blink()
	for i in 1:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._blue()
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 130), 1.5, 5.5, "right", 340)
	for i in 5:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2( - 10, 130), Vector2(0, 0), Vector2(10, 130), 1.0, 4.0, "right", 340)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in node.get_children():
		i._change_size(Vector2(10, 50), 1.5)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	for i in 6:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(320, 130), Vector2(0, 0), Vector2(10, 130), 0.8, 0.0, "right", 340)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, bullet.position.x - i * 30, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in node.get_children():
		tween.interpolate_property(i, "position:x", i.position.x, i.position.x + 260, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	for i in 13:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 130), 0.8, 0.0, "left", - 20)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, bullet.position.x + i * 20, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in node.get_children():
		tween.interpolate_property(i, "position:x", i.position.x, i.position.x - 300, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in 7:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet._cast_bullet(Vector2(0 + i * 16, 0), Vector2(0, 0), Vector2(10, 130), 0.5, 0.0, "right", 340)
		
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet._cast_bullet(Vector2(320 - i * 16, 0), Vector2(0, 0), Vector2(10, 130), 0.5, 0.0, "left", - 20)
		
		
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	for i in node.get_children():
		i._blue()
		if i.position.x < 160:
			tween.interpolate_property(i, "position:x", i.position.x, 400, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
		if i.position.x > 160:
			tween.interpolate_property(i, "position:x", i.position.x, - 80, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	for i in 4:
		var bulletfirst = bone_preload.instance()
		add_child(bulletfirst)
		bulletfirst._cast_bullet(Vector2( - 20, 0), Vector2(0, 0), Vector2(10, 80), 1.0, 5.0, "right", 340)
		var bulletsecond = bone_preload.instance()
		add_child(bulletsecond)
		bulletsecond._cast_bullet(Vector2(335, 0), Vector2(0, 0), Vector2(10, 80), 1.0, 5.0, "left", - 20)
		
		for j in 3:
			bullet = bone_preload.instance()
			bullet.rotation_degrees = 180
			add_child(bullet)
			bullet._cast_bullet(Vector2( - 10, 130), Vector2(0, 0), Vector2(10, 15 + (3 - j) * 8), 1.0, 5.0, "right", 340)
			bullet = bone_preload.instance()
			bullet.rotation_degrees = 180
			add_child(bullet)
			bullet._cast_bullet(Vector2(350, 130), Vector2(0, 0), Vector2(10, 15 + (3 - j) * 8), 1.0, 5.0, "left", - 20)
			yield(get_tree().create_timer(0.1, false), "timeout")
		
		yield(get_tree().create_timer(0.3, false), "timeout")
		if i == 3:
			bulletfirst._change_size(Vector2(10, 45), 0.8)
			bulletsecond._change_size(Vector2(10, 45), 0.8)
		else:
			bulletfirst._change_size(Vector2(10, 35), 0.8)
			bulletsecond._change_size(Vector2(10, 35), 0.8)
		yield(get_tree().create_timer(0.3, false), "timeout")
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(40, 0), Vector2( - 70, 0), Vector2(10, 45 + i * 10), 1.0, 4.5, "right", 400)
		if i < 2:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 20), 1.0, 4.5, "right", 340)
		if i == 5:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 30), 1.0, 4.5, "right", 340)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(0.56, false), "timeout")
	for i in 8:
		if i == 0 or i > 1:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 55), 1.0, 5.0, "right", 400)
		if i == 1:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 75), 1.0, 4.7, "right", 340)
		if i > 1:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2( - 12, 0), Vector2(0, 0), Vector2(10, 35), 1.0, 5.0, "right", 400)
		if i <= 1: yield(get_tree().create_timer(0.3, false), "timeout")
		else: yield(get_tree().create_timer(0.08, false), "timeout")
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	_attack_part_3_puzzles()

func _attack_part_3_puzzles():
	box_main._box_resize(Vector2(40, 130), Vector2( - 30, 0), 2.0)
	
	
	
	
	yield(get_tree().create_timer(1.1, false), "timeout")
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	papyrus_spr._shake_to_idle()
	
	is_blue_down = false
	is_red = true
	soul._blink()
	
	
	soul.hp = 20
	$Heal.play()
	
	box_main._box_resize(Vector2(340, 130), Vector2(0, 0), 1.2)
	
	var endbone = bone_preload.instance()
	endbone.rotation_degrees = 180
	add_child(endbone)
	endbone._cast_bullet(Vector2( - 30, 140), Vector2(0, 0), Vector2(10, 140), 1.0, 1.12, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(55, 140), Vector2(0, 0), Vector2(10, 35), 1.0, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(40, 0), Vector2(0, 0), Vector2(10, 60), 1.0, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(70, 140), Vector2(0, 0), Vector2(10, 40), 1.1, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(55, 0), Vector2(0, 0), Vector2(10, 55), 1.3, 0.0, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(105, 140), Vector2(0, 0), Vector2(10, 100), 1.4, 0.0, "right", 360)
	
	for i in 10:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(145 + i * 12, 140), Vector2(0, 0), Vector2(10, 70), 1.4 + i / 3, 0.0, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(145 - 12, 0), Vector2(0, 0), Vector2(10, 30), 1.4, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(215 - 12, 0), Vector2(0, 0), Vector2(10, 30), 1.5, 0.0, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(180, 140), Vector2(0, 70), Vector2(10, 30), 1.3, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(250, 140), Vector2(0, 70), Vector2(10, 30), 1.3, 0.0, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(270, 0), Vector2(0, 0), Vector2(10, 55), 1.7, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(282, 0), Vector2(0, 0), Vector2(10, 55), 1.8, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(294, 0), Vector2(0, 0), Vector2(10, 55), 1.9, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(306, 0), Vector2(0, 0), Vector2(10, 20), 2.0, 0.0, "right", 360)
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(270 + 12, 140), Vector2(0, 0), Vector2(10, 50), 1.6, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(282 + 12, 140), Vector2(0, 0), Vector2(10, 50), 1.7, 0.0, "right", 360)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(294 + 12, 140), Vector2(0, 0), Vector2(10, 50), 1.8, 0.0, "right", 360)
	
	yield(get_tree().create_timer(7.6, false), "timeout")
	is_red = false
	is_blue_up = true
	soul._blink()
	
	endbone._blue()
	
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	endbone = bone_preload.instance()
	endbone.rotation_degrees = 180
	add_child(endbone)
	endbone._cast_bullet(Vector2(380, 140), Vector2(0, 0), Vector2(10, 140), 1.0, - 1.0, "right", 390)
	
	yield(get_tree().create_timer(7.6, false), "timeout")
	endbone._blue()
	
	for i in get_children():
		if i.get_index() > 4 and i.get_index() < get_child_count() - 1:
			i._blue()
			tween.interpolate_property(i, "position:x", i.position.x, i.position.x - 500, 1.5, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			yield(get_tree().create_timer(0.05, false), "timeout")
		if weakref(i).get_ref() and i.get_index() == get_child_count() - 1:
			yield(get_tree().create_timer(0.1, false), "timeout")
			i._blue()
			tween.interpolate_property(i, "position:x", i.position.x, i.position.x + 500, 1.5, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			yield(get_tree().create_timer(0.05, false), "timeout")
	yield(get_tree().create_timer(1.6, false), "timeout")
	
	_attack_part_4_sides()

func _attack_part_4_sides():
	is_blue_up = false
	is_red = true
	soul._blink()
	
	_attack_part_4_inner()
	
	box_main._box_retween(270, 140, - 70, 0, 1.0)
	
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	for i in 8:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(12 + i * 12, 140), Vector2(0, 0), Vector2(10, 140), 1.6, 0.0, "left", - 10)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(278 - i * 12, 140), Vector2(0, 0), Vector2(10, 140), 1.6, 0.0, "right", 280)
		if i != 3: yield(get_tree().create_timer(0.05, false), "timeout")
		else: yield(get_tree().create_timer(2.0, false), "timeout")
		if i == 0:
			pass
			

func _attack_part_4_inner():
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(135, 10), 2.0, 0.0, "right", 400)
		bullet.global_position.y = soul.global_position.y
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.x = - 1
		bullet._cast_bullet(Vector2(270, 0), Vector2(0, 0), Vector2(135, 10), 2.0, 0.0, "right", 400)
		bullet.global_position.y = soul.global_position.y
		
		if i == 0:
			camera._resize_cam_out(Vector2(320, 270), Vector2(0.8, 0.8), 1.8)
			camera.darken_with_set_values(0.0, 0.3, 1.8)
		if i == 2:
			camera._resize_cam_out(Vector2(320, 300), Vector2(0.6, 0.6), 1.8)
			camera.darken_with_set_values(0.3, 0.5, 1.8)
			
		if i != 3: yield(get_tree().create_timer(1.1, false), "timeout")
		
	
		else: yield(get_tree().create_timer(0.5, false), "timeout")
	
	camera._resize_cam_out(Vector2(320, 320), Vector2(0.56, 0.56), 0.6)
	camera.darken_with_set_values(0.5, 1.0, 0.6)
	
	tween.start()
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	_attack_part_5()

func _attack_part_5():
	camera.position = Vector2(320, 240)
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 2.5)
	camera.darken_with_set_values(1, 0, 0.8)
	papyrus_spr._shake_to_battle()
	for i in get_children():
		if weakref(i).get_ref() and i.get_index() > 4:
			remove_child(i)
	_attack_part_5_sidebones()
	for i in 8:
		if i % 2 == 0:
			for j in 2:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._blue()
				bullet._cast_bullet(Vector2(10, 140), Vector2(0, 0), Vector2(10, 140), 1.5, 3.0, "right", 280)
				tween.interpolate_property(bullet, "rotation_degrees", 160, 180, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				yield(get_tree().create_timer(0.25, false), "timeout")
			yield(get_tree().create_timer(0.1, false), "timeout")
			var bullet1 = bone_preload.instance()
			add_child(bullet1)
			bullet1._cast_bullet(Vector2(20, 0), Vector2(0, 0), Vector2(10, 70), 1.1, 0.0, "right", 280)
			var bullet2 = bone_preload.instance()
			add_child(bullet2)
			bullet2.rotation_degrees = 180
			bullet2._cast_bullet(Vector2(260, 140), Vector2(0, 0), Vector2(10, 70), 1.1, 0.0, "left", - 10)
			
			yield(get_tree().create_timer(0.5, false), "timeout")
			tween.interpolate_property(bullet1, "position:x", bullet1.position.x, 290, 2.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween.interpolate_property(bullet2, "position:x", bullet2.position.x, - 20, 2.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween.start()
	
		if i % 2 == 1:
			for j in 2:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._blue()
				bullet._cast_bullet(Vector2(260, 140), Vector2(0, 0), Vector2(10, 140), 1.5, 3.0, "left", - 10)
				tween.interpolate_property(bullet, "rotation_degrees", 200, 180, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				yield(get_tree().create_timer(0.25, false), "timeout")
			yield(get_tree().create_timer(0.1, false), "timeout")
			var bullet1 = bone_preload.instance()
			add_child(bullet1)
			bullet1._cast_bullet(Vector2(250, 0), Vector2(0, 0), Vector2(10, 70), 1.1, 0.0, "left", - 10)
			var bullet2 = bone_preload.instance()
			add_child(bullet2)
			bullet2.rotation_degrees = 180
			bullet2._cast_bullet(Vector2(30, 140), Vector2(0, 0), Vector2(10, 70), 1.1, 0.0, "right", 280)
			
			yield(get_tree().create_timer(0.5, false), "timeout")
			tween.interpolate_property(bullet1, "position:x", bullet1.position.x, - 20, 2.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween.interpolate_property(bullet2, "position:x", bullet2.position.x, 290, 2.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween.start()
			
		yield(get_tree().create_timer(0.9, false), "timeout")
	
	_attack_part_6()

func _attack_part_5_sidebones():
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in 45:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(270, 0), Vector2(0, 0), Vector2(10, 18), 0.8, 4.5, "left", - 10)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(260, 140), Vector2(0, 0), Vector2(10, 18), 0.8, 4.5, "left", - 10)
		yield(get_tree().create_timer(0.16, false), "timeout")
	for i in 45:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(270, 0), Vector2(0, 0), Vector2(10, 18 + i / 2), 0.8, 4.5, "left", - 10)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(260, 140), Vector2(0, 0), Vector2(10, 18 + i / 2), 0.8, 4.5, "left", - 10)
		yield(get_tree().create_timer(0.16, false), "timeout")

func _attack_part_6():
	yield(get_tree().create_timer(0.35, false), "timeout")
	_attack_part_6_sidebones()
	is_red = false
	is_blue_down = true
	soul._blink()
	
	for i in 8:
		if i % 2 == 0:
			for j in 2:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 3.8, "right", 280)
				tween.interpolate_property(bullet, "rotation_degrees", - 20, 0, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(270, 140), Vector2(0, 0), Vector2(10, 30), 1.0, 3.8, "left", - 20)
				tween.interpolate_property(bullet, "rotation_degrees", 200, 180, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				yield(get_tree().create_timer(0.55, false), "timeout")
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet._cast_bullet(Vector2(270, 140), Vector2(0, 0), Vector2(10, 140), 1.0, 3.8, "left", - 20)
			tween.interpolate_property(bullet, "rotation_degrees", 200, 180, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
			yield(get_tree().create_timer(0.9, false), "timeout")
		
		if i % 2 == 1:
			for j in 2:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(270, 0), Vector2(0, 0), Vector2(10, 100), 1.0, 3.8, "left", - 20)
				tween.interpolate_property(bullet, "rotation_degrees", 20, 0, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(0, 140), Vector2(0, 0), Vector2(10, 30), 1.0, 3.8, "right", 280)
				tween.interpolate_property(bullet, "rotation_degrees", 160, 180, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				yield(get_tree().create_timer(0.55, false), "timeout")
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet._cast_bullet(Vector2(0, 140), Vector2(0, 0), Vector2(10, 140), 1.0, 3.8, "right", 280)
			tween.interpolate_property(bullet, "rotation_degrees", 160, 180, 1.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
			yield(get_tree().create_timer(0.9, false), "timeout")
	
	_pause_period()
func _attack_part_6_sidebones():
	for i in 90:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 50 + i / 10), 1.0, 4.5, "right", 280)
		yield(get_tree().create_timer(0.16, false), "timeout")
		
		if i == 45:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(12, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "left", - 30)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "right", 290)
		if i == 55:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(24, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "left", - 30)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(248, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "right", 290)
		if i == 65:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(36, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "left", - 30)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(236, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "right", 290)
		if i == 75:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(48, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "left", - 30)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(224, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "right", 290)
		if i == 85:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(60, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "left", - 30)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(212, 0), Vector2(0, 0), Vector2(10, 140), 1.5, 0.0, "right", 290)

onready var dialbox = get_node("/root/Battle_Engine/Dialogue_Manager")

func _pause_period():
	tween.interpolate_property(main.get_child(2), "modulate:a", 1.0, 0.0, 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	_dialogue_section_1()
	
	papyrus_spr._shake_to_idle()
	
	yield(get_tree().create_timer(8.0, false), "timeout")
	main.get_child(2).hide()
	box_main._box_flash(1.5)
	soul.hp = 20
	$Heal.play()
	camera._cam_beat(0.2)
	for i in get_children():
		if weakref(i).get_ref() and i.get_index() > 4:
			remove_child(i)
	yield(get_tree().create_timer(10.5, false), "timeout")
	
	main.get_child(15).emitting = true
	
	yield(get_tree().create_timer(2.0, false), "timeout")
	tween.interpolate_property(music, "volume_db", - 90, 0, 2.5, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	music.play(137.0 - 5.5)
	yield(get_tree().create_timer(4.0, false), "timeout")
	camera.darken_with_set_values(0.0, 1.0, 0.9)
	
	yield(get_tree().create_timer(1.5, false), "timeout")
	
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 1.0)
	camera.rotation_degrees = 0.0
	_attack_part_7()
	dialbox.hide()

func _dialogue_section_1():
	
	dialbox._cast_dialogue_inbattle("У ТЕБЯ ХОРОШО ПОЛУЧАЕТСЯ, ЧЕЛОВЕК!")
	yield(get_tree().create_timer(4.5, false), "timeout")
	dialbox._cast_dialogue_inbattle("ОДНАКО, ТО, ЧТО ПРОИЗОЙДЁТ ДАЛЬШЕ, ЗАСТАВИТ ТЕБЯ НАПРЯЧЬСЯ...")
	yield(get_tree().create_timer(3.5, false), "timeout")
	dialbox._cast_dialogue_inbattle("ВЕДЬ ПРИШЛО ВРЕМЯ ДЛЯ МОЕЙ СПЕЦИАЛЬНОЙ АТАКИ!")
	tween.interpolate_property(music, "volume_db", 0, - 90, 11.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(5.0, false), "timeout")
	dialbox._cast_dialogue_inbattle("ОХ, Я  ТАК ДАВНО ЭТОГО НЕ ГОВОРИЛ...")
	yield(get_tree().create_timer(5.0, false), "timeout")
	dialbox._cast_dialogue_inbattle("В ЛЮБОМ СЛУЧАЕ, ТЕПЕРЬ...")
	yield(get_tree().create_timer(4.0, false), "timeout")
	dialbox._cast_dialogue_inbattle("...СЕЙЧАС, ИЛИ НИКОГДА!! НЬЕХ-ХЕХ-ХЕ!!!")
	
	
	
	

func _attack_part_7():
	papyrus_spr._shake_to_battle()
	main.get_child(2).modulate.a = 1.0
	main.get_child(2).show()
	camera.flash(1.0)
	box_main._box_retween(190, 160, box_arena.rect_position.x + 45, box_arena.rect_position.y - 10, 1.0)
	
	is_red = false
	is_blue_down = true
	soul._blink()
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 80), 1.0, 3.2, "right", 210)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._cast_bullet(Vector2(12, 160), Vector2(0, 0), Vector2(10, 20), 1.0, 3.2, "right", 210)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2( - 95, 0), Vector2(0, 0), Vector2(10, 120), 2.0, 4.0, "right", 210)
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._blue()
	bullet._cast_bullet(Vector2( - 50, 0), Vector2(0, 0), Vector2(10, 150), 2.0, 3.2, "right", 210)
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(12 + i * 12, 160), Vector2(0, 0), Vector2(10, 160), 1.0, 0.0, "right", 210)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(200 - i * 12, 160), Vector2(0, 0), Vector2(10, 160), 1.0, 0.0, "left", - 10)
		
		if i < 1:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(200, 0), Vector2(0, 0), Vector2(10, 100), 1.0, 3.6, "left", - 10)
		yield(get_tree().create_timer(0.11, false), "timeout")
	
	yield(get_tree().create_timer(0.12, false), "timeout")
	
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(200, 160), Vector2(0, 0), Vector2(10, 35 + i * 10), 1.0, 3.6, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	is_blue_down = false
	is_red = true
	soul._blink()
	
	for i in 4:
		if i < 2:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 77), 0.8, 4.0, "right", 210)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(200, 160), Vector2(0, 0), Vector2(10, 77), 0.8, 4.0, "left", - 10)
		else:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(200, 0), Vector2(0, 0), Vector2(10, 77), 0.8, 4.0, "left", - 10)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 77), 0.8, 4.0, "right", 210)
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	
	
	is_red = false
	is_blue_up = true
	soul._blink()
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 55 + i * 10), 1.0, 4.8, "right", 210)
		if i == 3:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2( - 12, 0), Vector2(0, 0), Vector2(10, 30), 1.0, 4.0, "right", 210)
		
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2( - 12, 0), Vector2(0, 0), Vector2(10, 20), 1.0, 4.0, "right", 210)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(200, 160), Vector2(0, 0), Vector2(10, 75), 1.0, 4.2, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(200, 0), Vector2(0, 0), Vector2(10, 25), 1.0, 5.0, "left", - 10)
		if i == 5:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._blue()
			bullet._cast_bullet(Vector2(188, 160), Vector2(0, 0), Vector2(10, 125), 2.0, 5.5, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	is_blue_up = false
	is_red = true
	soul._blink()
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, - 10), Vector2(0, 0), Vector2(92, 8), 0.8, 0.0, "left", - 110)
		tween.interpolate_property(bullet, "position:y", bullet.position.y, bullet.position.y + 180, 1.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(200, 170), Vector2(0, 0), Vector2(92, 8), 0.8, 0.0, "right", 310)
		tween.interpolate_property(bullet, "position:y", 170, - 10, 1.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	yield(get_tree().create_timer(0.35, false), "timeout")
	for i in 3:
		if i % 2 == 0:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 160), 0.8, 4.5, "right", 210)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(40, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 0.0, "right", 210)
			tween.interpolate_property(bullet, "position:x", 40, 220, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(150, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 0.0, "left", - 10)
			tween.interpolate_property(bullet, "position:x", 150, - 20, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			yield(get_tree().create_timer(0.7, false), "timeout")
			for j in 5:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet.scale.y = - 1
				bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 70), 2.8, 4.2, "right", 210)
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet.scale.y = - 1
				bullet._cast_bullet(Vector2(200, 160), Vector2(0, 0), Vector2(10, 70), 2.8, 4.2, "left", - 10)
				yield(get_tree().create_timer(0.1, false), "timeout")
			
		else:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(200, 160), Vector2(0, 0), Vector2(10, 160), 0.8, 4.5, "left", - 10)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(60, 160), Vector2(0, 0), Vector2(10, 90), 1.0, 0.0, "right", 210)
			tween.interpolate_property(bullet, "position:x", 60, 220, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN)
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.rotation_degrees = 180
			bullet._cast_bullet(Vector2(160, 160), Vector2(0, 0), Vector2(10, 90), 1.0, 0.0, "left", - 10)
			tween.interpolate_property(bullet, "position:x", 160, - 20, 1.1, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			yield(get_tree().create_timer(0.7, false), "timeout")
			for j in 5:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 70), 2.8, 4.2, "right", 210)
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(200, 0), Vector2(0, 0), Vector2(10, 70), 2.8, 4.2, "left", - 10)
				yield(get_tree().create_timer(0.1, false), "timeout")
		
		yield(get_tree().create_timer(0.8, false), "timeout")
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(200, 8), 0.6, 0.0, "right", 210)
		tween.interpolate_property(bullet, "position:y", 0, i * 30 + 30, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		camera.darken_with_set_values(i * 0.2, (i + 1) * 0.2, 0.7)
		
		camera._resize_cam_out(Vector2(320, 240 + i * 10), Vector2(1.0 - i * 0.15, 1.0 - i * 0.15), 0.8)
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	camera._resize_cam_out(Vector2(320, 240), Vector2(1, 1), 1.5)
	camera.flash(2.0)
	for i in get_children():
		if weakref(i).get_ref() and i.get_index() > 4:
			remove_child(i)
	
	box_main._box_retween(280, 160, box_arena.rect_position.x - 40, box_arena.rect_position.y, 0.8)
	is_red = false
	is_blue_down = true
	soul._blink()
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 35 + i * 12), 1.0, 4.6, "right", 290)
		tween.interpolate_property(bullet, "rotation_degrees", - 30, 0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 100), 1.0, 5.5, "left", - 10)
		tween.interpolate_property(bullet, "rotation_degrees", 30, 0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(20, 160), Vector2( - 10, 0), Vector2(10, 65), 1.0, 0.0, "right", 300)
	tween.interpolate_property(bullet, "position:x", bullet.position.x, 310, 1.4, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet.get_child(0).rect_size.y = 120
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 30), 1.0, 5.5, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet.get_child(0).rect_size.y = 120
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 30), 1.0, 5.5, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(60, - 10), Vector2(0, 0), Vector2(10, 110), 1.0, 0.0, "right", 290)
	tween.interpolate_property(bullet, "rotation_degrees", 0, - 110, 1.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(220, - 10), Vector2(0, 0), Vector2(10, 110), 1.0, 0.0, "right", 290)
	tween.interpolate_property(bullet, "rotation_degrees", 0, 110, 1.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet.get_child(0).rect_size.y = 120
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 30), 1.0, 6.0, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet.get_child(0).rect_size.y = 120
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 30), 1.0, 6.0, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 85), 1.0, 4.5, "left", - 10)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 35), 1.0, 4.5, "left", - 10)
		yield(get_tree().create_timer(0.5, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._blue()
	bullet._cast_bullet(Vector2( - 10, 160), Vector2(0, 0), Vector2(10, 160), 1.0, 4.6, "right", 290)
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(20, 0), Vector2( - 75, 0), Vector2(10, 60), 1.0, 4.5, "right", 400)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(20, 160), Vector2( - 75, 0), Vector2(10, 60), 1.0, 4.5, "right", 400)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	is_blue_down = false
	is_red = true
	soul._blink()
	
	for i in 4:
		if i % 2 == 0:
			for j in 3:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet.scale.y = - 1
				bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 75), 1.0, 4.8, "right", 290)
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet.scale.y = - 1
				bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 75), 1.0, 4.8, "left", - 10)
				yield(get_tree().create_timer(0.1, false), "timeout")
		else:
			for j in 3:
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 75), 1.0, 4.8, "right", 290)
				bullet = bone_preload.instance()
				add_child(bullet)
				bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 75), 1.0, 4.8, "left", - 10)
				yield(get_tree().create_timer(0.1, false), "timeout")
		yield(get_tree().create_timer(0.18, false), "timeout")
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	is_red = false
	is_blue_down = true
	soul.slam_multiplier = 2.0
	soul._blink()
	
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 110), 1.0, 4.7, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 110), 1.0, 4.7, "left", - 10)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 20), 1.0, 4.7, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 20), 1.0, 4.7, "left", - 10)
		
		if i == 2:
			tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x - 10, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
		if i == 4:
			tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x + 20, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
		yield(get_tree().create_timer(0.72, false), "timeout")
	tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x - 10, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	bullet = dog.instance()
	add_child(bullet)
	bullet._cast_dog(Vector2( - 20, 160), Vector2(320, 160), Vector2( - 1, 1), 1.7)
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 70 - i * 45), 1.0, 4.5, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 50), 1.0, 4.8, "left", - 10)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 100), 1.0, 6.0, "right", 290)
		yield(get_tree().create_timer(0.4, false), "timeout")
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	for i in 6:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(10 + i * 12, 160), Vector2(0, 0), Vector2(10, 160), 1.0, 0, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(270 - i * 12, 160), Vector2(0, 0), Vector2(10, 160), 1.0, 0, "left", - 10)
	
	for i in 2:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 160), Vector2(0, 0), Vector2(10, 30 + i * 15), 1.0, 5.5, "right", 290)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(280, 160), Vector2(0, 0), Vector2(10, 30 + i * 15), 1.0, 5.5, "left", - 10)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	bullet = blaster.instance()
	main.add_child(bullet)
	main.move_child(bullet, 11)
	bullet._cast_blaster( - 50, 160, 320, 160, 0, 0, 2.2, 25)
	bullet.scale.y = 2.0
	bullet = glasses.instance()
	main.add_child(bullet)
	main.move_child(bullet, 12)
	bullet.set_process(false)
	bullet.scale.x = 2.2
	bullet.scale.y = 2.2
	tween.interpolate_property(bullet, "position", Vector2( - 50, 166), Vector2(320, 166), 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	camera.darken_with_set_values(0.0, 0.4, 0.8)
	camera._resize_cam_out(Vector2(320, 260), Vector2(0.6, 0.6), 0.9)
	yield(get_tree().create_timer(1, false), "timeout")
	camera.flash(8.0)
	wallnode.hide()
	camera._resize_cam_out(Vector2(320, 240), Vector2(1.0, 1.0), 4.5)
	box_main._box_flash(3.0)
	bullet.set_process(true)
	for i in get_children():
		if weakref(i).get_ref() and i.get_index() > 4:
			remove_child(i)
	yield(get_tree().create_timer(1, false), "timeout")
	_ending()
	

func _ending():
	papyrus_spr._shake_to_idle()
	for i in 40:
		var dir
		var margin
		var start_y = 0
		var start_x
		var n = int(rand_range(0.1, 1.9))
		if n == 0:
			n = - 1
			start_y = 160
		var dirval = int(rand_range(0.1, 1.9))
		if dirval == 0:
			dir = "right"
			margin = 290
			start_x = 0
		if dirval == 1:
			dir = "left"
			margin = - 10
			start_x = 280
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = n
		bullet._blue()
		bullet._cast_bullet(Vector2(start_x, start_y), Vector2(0, 0), Vector2(10, rand_range(25, 140)), 1.0, rand_range(2.0, 5.0), dir, margin)
		if i < 28: yield(get_tree().create_timer(0.22, false), "timeout")
		else: yield(get_tree().create_timer(0.4, false), "timeout")
		
	yield(get_tree().create_timer(1, false), "timeout")
	main.get_child(16).emitting = false
	dialbox.show()
	
	papyrus_spr.find_node("Idle").find_node("Head").frame = 3
	dialbox._cast_dialogue_inbattle("П-ПОХОЖЕ, ТЕБЕ УДАЛОСЬ... ПОБЕДИТЬ МЕНЯ, ВЕЛИКОГО ПАПИРУСА...")
	yield(get_tree().create_timer(6, false), "timeout")
	dialbox._cast_dialogue_inbattle("ПРОЙДЯ ЧЕРЕЗ АГОНИЮ... ЭТО...")
	yield(get_tree().create_timer(1.5, false), "timeout")
	camera.darken_with_set_values(0.0, 0.4, 1.5)
	camera._resize_cam_out(Vector2(320, 180), Vector2(0.7, 0.7), 2.0)
	yield(get_tree().create_timer(2.5, false), "timeout")
	camera.darken_with_set_values(0.4, 0.0, 1.0)
	camera._resize_cam_out(Vector2(320, 240), Vector2(1.0, 1.0), 1.5)
	papyrus_spr._emit()
	papyrus_spr.find_node("Idle").find_node("Head").frame = 2
	dialbox._cast_dialogue_inbattle("...ГРАНДИОЗНАЯ ПОБЕДА!!")
	yield(get_tree().create_timer(2.8, false), "timeout")
	papyrus_spr.find_node("Idle").find_node("Head").frame = 0
	dialbox._cast_dialogue_inbattle("ПОЗДРАВЛЯЮ, ЧЕЛОВЕК!! ТЫ ПРЕВЗОШЛА МЕНЯ - И ПОЭТОМУ, ПРОШЛА МОЁ ИСПЫТАНИЕ!")
	yield(get_tree().create_timer(6, false), "timeout")
	dialbox._cast_dialogue_inbattle("КАК ВЕЛИКИЙ ПАПИРУС, ТВОЙ ВЫДАЮЩИЙСЯ НАСТАВНИК, Я ОЧЕНЬ ГОРЖУСЬ ТОБОЙ!")
	yield(get_tree().create_timer(5, false), "timeout")
	camera.darken(1, 3)
	PlayerData.finishedAreas[0] = true
	PlayerData._save_game()
	yield(get_tree().create_timer(3, false), "timeout")
	get_tree().change_scene("res://Overworld/Rooms/Snowdin_end.tscn")
