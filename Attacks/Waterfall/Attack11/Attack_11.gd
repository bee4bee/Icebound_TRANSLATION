extends Node2D

onready var main = get_node("/root/Battle_Engine")
onready var blasterNode = get_node("/root/Battle_Engine/BlasterNode")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var sanssprite = get_node("/root/Battle_Engine/Battle_Sprites/Sans")
onready var floweysprite = get_node("/root/Battle_Engine/Battle_Sprites/Flowey")
onready var soul = get_node("/root/Battle_Engine/Player_Soul")

var bone = preload("res://Bullets/Bone/Bone.tscn")



var platform = preload("res://Bullets/Platform_Pink/Platform_Pink.tscn")




var arrow = preload("res://Bullets/Arrow/Arrow.tscn")

var bullet
var blast
var platform_move
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

func _ready():
	add_child(tween)
	box_main._box_retween(260, 130, box_arena.rect_position.x - 30, box_arena.rect_position.y - 5, 1.0)
	_attack()

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()

func _attack():
	is_blue_up = true
	is_red = false
	soul.slam_multiplier = 5.0
	sanssprite._slamUp()
	yield(get_tree().create_timer(0.45, false), "timeout")
	for i in 2:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 6.0, "right", 260)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 6.0, "left", 0)
		yield(get_tree().create_timer(0.15, false), "timeout")
	for i in 2:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 35), 1.0, 6.0, "right", 260)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 35), 1.0, 6.0, "left", 0)
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	_bones_up()
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	bullet = platform.instance()
	add_child(bullet)
	bullet.scale = Vector2(0.7, - 1)
	bullet._cast_platform_direct(Vector2(280, 30), - 2.0, - 20)
	
	yield(get_tree().create_timer(1.1, false), "timeout")
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 80), 0.8, 5.5, "right", 260)
	$swipe.play()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	bullet = platform.instance()
	add_child(bullet)
	bullet.scale = Vector2(0.7, - 1)
	bullet._cast_platform_direct(Vector2(280, 80), - 2.0, - 20)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 70), 0.2, 5.5, "left", 0)
		$swipe.play()
		yield(get_tree().create_timer(0.45, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	platform_move = platform.instance()
	add_child(platform_move)
	platform_move.scale = Vector2(1, - 1)
	platform_move._cast_platform_direct(Vector2(280, 35), 0.0, - 20)
	tween.interpolate_property(platform_move, "position:x", 280, 130, 3.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	for i in 3:
		bullet = bone.instance()
		$appear.play()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(200 + i * 20, 130), Vector2(0, 0), Vector2(10, 75), 1.0, 0.0, "left", 0)
		tween.interpolate_property(bullet, "position:x", bullet.position.x, bullet.position.x - 300, 1.6, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(2.0, false), "timeout")
	for i in 5:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 85), 1.0, 4.5, "right", 260)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 85), 1.0, 4.5, "left", 0)
		$swipe.play()
		
		if i == 1 or i == 3:
			bullet = bone.instance()
			add_child(bullet)
			bullet._blue()
			if i == 1: bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 130), 1.2, 3.0, "right", 260)
			if i == 3: bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 130), 1.2, 3.0, "left", 0)
		
		if i == 4:
			tween.interpolate_property(platform_move, "position:y", 35, - 30, 1.4, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
		yield(get_tree().create_timer(1.0, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 10 + i * 15), Vector2(0, 0), Vector2(10, 10), 0.2, 0.0, "right", 300)
		tween.interpolate_property(bullet.get_child(0), "rect_size:x", 10, 260, 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	$Impact.play()
	
	_remove_assets()
	box_main._box_flash(3.0)
	camera.add_trauma(0.6)
	
	_bones_bothsides()
	_platforms_bothsides()
	_bonespawns()

func _bones_up():
	for i in 95:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 20), 0.6, 5.0, "left", 0)
		yield(get_tree().create_timer(0.1, false), "timeout")

func _bones_bothsides():
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	for i in 104:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 20), 0.6, 5.0, "left", 0)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 20), 0.6, 5.0, "right", 260)
		yield(get_tree().create_timer(0.1, false), "timeout")

func _platforms_bothsides():
	for i in 8:
		bullet = platform.instance()
		add_child(bullet)
		bullet._cast_platform_direct(Vector2( - 40, 100), 2.2, 300)
		bullet = platform.instance()
		add_child(bullet)
		bullet.scale = Vector2(1, - 1)
		bullet._cast_platform_direct(Vector2(300, 30), - 2.2, - 40)
		
		if i % 3 != 0: yield(get_tree().create_timer(1.8, false), "timeout")
		if i % 3 == 0:
			bullet = arrow.instance()
			add_child(bullet)
			if i % 6 == 0: bullet._cast_arrow(Vector2(130, 65), 180)
			else: bullet._cast_arrow(Vector2(130, 65), 0)
			
			yield(get_tree().create_timer(0.6, false), "timeout")
			if i % 6 == 0:
				is_blue_up = true
				is_blue_down = false
				soul.slam_multiplier = 5.0
				sanssprite._slamUp()
			else:
				is_blue_down = true
				is_blue_up = false
				soul.slam_multiplier = 5.0
				sanssprite._slamDown()
			soul._blinksound()
			yield(get_tree().create_timer(1.2, false), "timeout")

func _bonespawns():
	for i in 8:
		bullet = bone.instance()
		add_child(bullet)
		if i % 2 == 0: bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 44), 1.0, 4.2, "right", 260)
		if i % 2 == 1: bullet._cast_bullet(Vector2(260, 0), Vector2(0, 0), Vector2(10, 44), 1.0, 4.2, "left", 0)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		if i % 2 == 0: bullet._cast_bullet(Vector2(0, 130), Vector2(0, 0), Vector2(10, 44), 1.0, 4.2, "right", 260)
		if i % 2 == 1: bullet._cast_bullet(Vector2(260, 130), Vector2(0, 0), Vector2(10, 44), 1.0, 4.2, "left", 0)
		$swipe.play()
		if i < 7: yield(get_tree().create_timer(1.8, false), "timeout")
		else: yield(get_tree().create_timer(0.4, false), "timeout")
	
	
	_remove_assets()
	camera._flash_dark(0.5)
	_attack1()

func _attack1():
	is_blue_down = true
	is_blue_up = false
	box_main._box_retween(280, 140, box_arena.rect_position.x - 55, box_arena.rect_position.y, 0.4)
	yield(get_tree().create_timer(0.5, false), "timeout")
	soul.position.x += 50
	
	for i in 12:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 140), Vector2(0, 0), Vector2(10, 30 + int(i / 8) * 70), 0.8, 6.1, "right", 280)
		yield(get_tree().create_timer(0.08, false), "timeout")
	
	_remove_assets()
	camera._flash_dark(0.5)
	box_main._box_retween(250, 100, box_arena.rect_position.x + 120, box_arena.rect_position.y - 20, 0.4)
	bullet = platform.instance()
	add_child(bullet)
	bullet.position = Vector2(125, 50)
	soul.position = bullet.global_position + Vector2(150, - 10)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	
	var x = int(rand_range(0.1, 1.9))
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	
	if x == 0: bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 40), 0.7, 5.0, "right", 250)
	if x == 1: bullet._cast_bullet(Vector2(250, 0), Vector2(0, 0), Vector2(10, 40), 0.7, 5.0, "left", 0)
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	if x == 1: bullet._cast_bullet(Vector2(0, 100), Vector2(0, 0), Vector2(10, 40), 0.7, 5.0, "right", 250)
	if x == 0: bullet._cast_bullet(Vector2(250, 100), Vector2(0, 0), Vector2(10, 40), 0.7, 5.0, "left", 0)
	
	
	yield(get_tree().create_timer(1.3, false), "timeout")
	camera._flash_dark(0.8)
	_remove_assets()
	box_main._box_retween(240, 110, - 120, - 10, 0.8)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	soul.position.x -= 100
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	for i in 4:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		if i == 0:
			bullet._blue()
			bullet._cast_bullet(Vector2(0, 110), Vector2(0, 0), Vector2(10, 110), 0.8, 6.5, "right", 240)
		if i == 1 or i == 2: bullet._cast_bullet(Vector2(0, 110), Vector2(0, 0), Vector2(10, 25), 0.8, 6.0, "right", 240)
		if i == 3: bullet._cast_bullet(Vector2(0, 110), Vector2(0, 0), Vector2(10, 110), 0.8, 6.0, "right", 240)
		
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		if i == 0:
			bullet._blue()
			bullet._cast_bullet(Vector2(240, 110), Vector2(0, 0), Vector2(10, 110), 0.8, 6.5, "left", 0)
		if i == 1 or i == 2: bullet._cast_bullet(Vector2(240, 110), Vector2(0, 0), Vector2(10, 25), 0.8, 6.0, "left", 0)
		if i == 3: bullet._cast_bullet(Vector2(240, 110), Vector2(0, 0), Vector2(10, 110), 0.8, 6.0, "left", 0)
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	camera._flash_dark(0.4)
	_remove_assets()
	yield(get_tree().create_timer(0.4, false), "timeout")
	main._return_to_selection()
	
func _remove_assets():
	for i in get_children():
		if i.get_index() > 3:
			self.remove_child(i)
