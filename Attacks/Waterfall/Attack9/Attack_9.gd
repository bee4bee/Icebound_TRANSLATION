extends Node2D

onready var main = get_node("/root/Battle_Engine")
onready var blasterNode = get_node("/root/Battle_Engine/BlasterNode")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var sanssprite = get_node("/root/Battle_Engine/Battle_Sprites/Sans")
onready var floweysprite = get_node("/root/Battle_Engine/Battle_Sprites/Flowey")
onready var soul = get_node("/root/Battle_Engine/Player_Soul")

var bone = load("res://Bullets/Bone/Bone.tscn")
var pellet = load("res://Bullets/Pellet/Pellet.tscn")
var vine = load("res://Bullets/Vine/Vine.tscn")
var blaster = load("res://Bullets/Blaster/Blaster.tscn")



var bullet
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false


func _ready():
	add_child(tween)
	box_main._box_retween(320, 150, box_arena.rect_position.x - 60, box_arena.rect_position.y, 1.0)
	_attack()


func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()


func _attack():
	_initial_pellet_spawn()
	_initial_bone_spawn()
	_side_bone_spawns()
	yield(get_tree().create_timer(4.0, false), "timeout")
	_additional_attack_sequence()

func _initial_pellet_spawn():
	for i in 16:
		bullet = pellet.instance()
		add_child(bullet)
		bullet._cast_bullet(325, rand_range(5, 145), 3.2, "left", - 10)
		$pellet.play()
		yield(get_tree().create_timer(0.8, false), "timeout")

func _initial_bone_spawn():
	for i in 11:
		bullet = bone.instance()
		add_child(bullet)
		if i % 2 == 0:
			bullet._cast_bullet(Vector2(10, 0), Vector2(0, 0), Vector2(10, 75), 1.0, 0.0, "right", 340)
		else:
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(10, 150), Vector2(0, 0), Vector2(10, 75), 1.0, 0.0, "right", 340)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, 350, 3.3, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(1.2, false), "timeout")

func _side_bone_spawns():
	for i in 55:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 65), 8.5, 4.5, "left", - 10)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(320, 150), Vector2(0, 0), Vector2(10, 65), 8.5, 4.5, "left", - 10)
		yield(get_tree().create_timer(0.22, false), "timeout")

func _additional_attack_sequence():
	
	var bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._blue()
	bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 150), 1.0, 0.0, "left", - 20)
	tween.interpolate_property(bullet, "position:x", - 10, 300, 3.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(3.0, false), "timeout")
	_addBlueBones()
	tween.interpolate_property(bullet, "position:x", 300, - 30, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	
	yield(get_tree().create_timer(3.5, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 100, 350, 100, 300, - 90, - 90, 1.6, 75)
	
	
	yield(get_tree().create_timer(3.0, false), "timeout")
	for i in 5:
		bullet = pellet.instance()
		add_child(bullet)
		bullet._cast_bullet(0, 10 + i * 10, 4.0, "right", 340)
		bullet = pellet.instance()
		add_child(bullet)
		bullet._cast_bullet(0, 140 - i * 10, 4.0, "right", 340)
		$pellet.play()
		yield(get_tree().create_timer(0.2, false), "timeout")
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	is_blue_down = true
	soul.slam_multiplier = 5.0
	sanssprite._slamDown()
	is_red = false
	soul._blink()
	
	
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 40), 1.0, 4.3, "right", 340)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 65), 1.0, 4.3, "right", 340)
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 50), 1.0, 6.0, "right", 340)
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 55), 1.0, 6.0, "right", 340)
	$swipe.play()
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	for i in 3:
		if i % 2 == 0:
			bullet = bone.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(320, 0), Vector2(0, 0), Vector2(10, 110), 1.0, 5.3, "left", - 10)
		
		if i % 2 == 1:
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(320, 150), Vector2(0, 0), Vector2(10, 40), 1.0, 5.3, "left", - 10)
		yield(get_tree().create_timer(0.3, false), "timeout")
	yield(get_tree().create_timer(0.9, false), "timeout")
	_end_segment()

func _addBlueBones():
	for i in 6:
		bullet = bone.instance()
		add_child(bullet)
		bullet._blue()
		if i % 2 == 0:
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 80), 1.0, 4.5, "right", 340)
		else: bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 80), 1.0, 4.5, "right", 340)
		
		tween.interpolate_property(bullet, "rotation_degrees", 30, 0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		
		$swipe.play()
		yield(get_tree().create_timer(1.1, false), "timeout")

func _end_segment():
	box_main._box_retween(300, 70, box_arena.rect_position.x + 10, box_arena.rect_position.y + 50, 1.0)
	yield(get_tree().create_timer(0.4, false), "timeout")
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(300, 0), Vector2(0, 0), Vector2(10, 35), 1.0, 5.4, "left", - 10)
		tween.interpolate_property(bullet, "rotation_degrees", - 30, 0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 70), Vector2(0, 0), Vector2(10, 35), 1.0, 5.4, "right", 320)
		tween.interpolate_property(bullet, "rotation_degrees", - 30, 0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.7, false), "timeout")
	
	
	for i in 5:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0 + i * 12, 70), Vector2(0, 0), Vector2(10, 70), 1.0, 0.0, "right", 320)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(290 - i * 12, 70), Vector2(0, 0), Vector2(10, 70), 1.0, 0.0, "left", - 10)
		$swipe.play()
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	for i in 10:
		var x = int(rand_range(0.1, 1.9))
		$pellet.play()
		for j in 3:
			bullet = pellet.instance()
			add_child(bullet)
			if x == 0: bullet._blue()
			else: bullet._orange()
			bullet._cast_bullet(0, 15 + j * 20, 4.8, "right", 320)
		yield(get_tree().create_timer(0.45, false), "timeout")
		
	_bonethrows()
	
	is_red = true
	is_blue_down = false
	soul._blink()
	
	bullet = vine.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(0, 55), - 90, 200)
	
	yield(get_tree().create_timer(1.5, false), "timeout")
	main._return_to_selection()

func _bonethrows():
	bullet = bone.instance()
	main.add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(320, 200), Vector2(0, 0), Vector2(10, 55), 1.0, 0.0, "right", 340)
	tween.interpolate_property(bullet, "position:y", 200, 560, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	bullet = bone.instance()
	main.add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(260, 200), Vector2(0, 0), Vector2(10, 55), 1.0, 0.0, "right", 320)
	tween.interpolate_property(bullet, "position:y", 200, 560, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
	bullet = bone.instance()
	main.add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(380, 200), Vector2(0, 0), Vector2(10, 55), 1.0, 0.0, "right", 400)
	tween.interpolate_property(bullet, "position:y", 200, 560, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	
