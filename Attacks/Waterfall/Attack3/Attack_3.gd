extends Node2D


onready var main = get_node("/root/Battle_Engine")
onready var blasterNode = get_node("/root/Battle_Engine/BlasterNode")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var sanssprite = get_node("/root/Battle_Engine/Battle_Sprites/Sans")
onready var floweysprite = get_node("/root/Battle_Engine/Battle_Sprites/Flowey")
onready var soul = get_node("/root/Battle_Engine/Player_Soul")

var bone_preload = preload("res://Bullets/Bone/Bone.tscn")

var pellet_preload = preload("res://Bullets/Pellet/Pellet.tscn")

var vine_preload = preload("res://Bullets/Vine/Vine.tscn")

var blaster_preload = preload("res://Bullets/Blaster/Blaster.tscn")

var index = 0
var bullet

var pos = 0.0
var node

var tween = Tween.new()

func _ready():
	box_main._box_retween(175, 300, - 20, - 175, 1.0)
	soul._blink()
	add_child(tween)
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
	
	for i in 20:
		if i % 2 == 1:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(0, 310), Vector2(0, 0), Vector2(10, 110), 1.0, 4.4, "right", 300)
			bullet.rotation_degrees = - 20
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(175, 310), Vector2(0, 0), Vector2(10, 110), 1.0, 4.4, "left", - 200)
			bullet.rotation_degrees = 20
		else:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(0, - 10), Vector2(0, 0), Vector2(10, 110), 1.0, 4.4, "right", 300)
			bullet.rotation_degrees = 20
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(175, - 10), Vector2(0, 0), Vector2(10, 110), 1.0, 4.4, "left", - 200)
			bullet.rotation_degrees = - 20
		
		if i > 2:
			var x = int(rand_range(0.1, 1.9))
			bullet = pellet_preload.instance()
			add_child(bullet)
			bullet.scale = Vector2(0.8, 0.8)
			if x == 0: bullet._cast_bullet(rand_range(10, 165), 0, 4.2, "down", 310)
			if x == 1: bullet._cast_bullet(rand_range(10, 165), 300, 4.2, "up", - 10)
			if i % 3 == 0:
				bullet = blaster_preload.instance()
				main.add_child(bullet)
				var n = int(rand_range(0.1, 1.9))
				if n == 0: bullet._cast_blaster( - 100, soul.position.y, 100, soul.position.y, 0, - 90, 1.4, 45)
				if n == 1: bullet._cast_blaster(800, soul.position.y, 540, soul.position.y, 0, 90, 1.4, 45)
		yield(get_tree().create_timer(0.4, false), "timeout")
	yield(get_tree().create_timer(1.2, false), "timeout")
	
	is_blue_down = true
	is_red = false
	soul.slam_multiplier = 5.0
	sanssprite._slamDown()
	box_main._box_retween(520, 125, - 175, 15, 2.0)
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	_bones_sides()
	_bones_middle()
	
	
	yield(get_tree().create_timer(1.6, false), "timeout")
	_blasters()
	tween.interpolate_property(box_arena, "rect_size:x", 520, 200, 12.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x + 200, 12.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(9.6, false), "timeout")
	camera._resize_camera(320, 240, 1.0, 1.0, 2.0)
	main._return_to_selection()

func _bones_sides():
	for i in 20:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(i * 12, 0), Vector2(0, 0), Vector2(10, 125), 1.2, 0.0, "right", 600)
		
		yield(get_tree().create_timer(0.85, false), "timeout")

func _bones_middle():
	for i in 32:
		if i % 2 == 0:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(box_arena.rect_size.x, 125), Vector2(0, 0), Vector2(10, 15), 0.5, 5.5, "left", 0)
			tween.interpolate_property(bullet, "rotation_degrees", 40, 0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
		if i % 2 == 1 and i > 8:
			$swipe.play()
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(box_arena.rect_size.x, 0), Vector2(0, 0), Vector2(10, 75), 0.5, 5.5, "left", 0)
			tween.interpolate_property(bullet, "rotation_degrees", - 40, 0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
		
		yield(get_tree().create_timer(0.3, false), "timeout")
		
		if i == 8:
			camera._resize_camera(320, 300, 0.8, 0.8, 1.5)
			camera.darken(0.4, 1.5)

func _blasters():
	for i in 8:
		bullet = blaster_preload.instance()
		main.add_child(bullet)
		bullet._cast_blaster(soul.position.x, - 55, soul.position.x, 200, - 180, 0, 1, 30)
		yield(get_tree().create_timer(1.2, false), "timeout")
