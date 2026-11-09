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
var pellet = preload("res://Bullets/Pellet/Pellet.tscn")

var blaster = preload("res://Bullets/Blaster/Blaster.tscn")





var bullet
var blast
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

func _ready():
	add_child(tween)
	box_main._box_retween(180, 180, box_arena.rect_position.x + 10, box_arena.rect_position.y - 25, 1.0)
	_attack()

var can_lookat = false

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()
		
	if can_lookat == true:
		blast.look_at(soul.position)
		blast.rotation_degrees -= 90
		yield(get_tree().create_timer(0.3, false), "timeout")
		can_lookat = false


func _attack():
	is_blue_down = true
	is_red = false
	bullet = bone.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(90, 0), Vector2(0, 0), Vector2(10, 10), 0.2, 0.0, "right", 200)
	tween.interpolate_property(bullet.get_child(0), "rect_size:y", 10, 180, 0.9, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(0.9, false), "timeout")
	$Impact.play()
	$Sparkle.play()
	camera.add_trauma(0.5)
	bullet._resize_bone(Vector2(10, 75), 1.5)
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(90, 180), Vector2(0, 0), Vector2(10, 65), 1.5, 0.0, "right", 200)
	_bone_waves()
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	_bone_slams()
	_bone_sides()
	_blaster_spawns()
	_bone_swipes()
	
func _bone_waves():
	var node = Node2D.new()
	add_child(node)
	for i in 7:
		bullet = bone.instance()
		node.add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(78 - i * 12, 180), Vector2(0, 0), Vector2(10, 30), 1.0, 0.0, "right", 200)
		bullet = bone.instance()
		node.add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(102 + i * 12, 180), Vector2(0, 0), Vector2(10, 30), 1.0, 0.0, "right", 240)
		yield(get_tree().create_timer(0.05, false), "timeout")
	
	for i in node.get_children():
		tween.interpolate_property(i, "position:y", 180, 230, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(0.01, false), "timeout")

func _bone_sides():
	for i in 33:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 200), Vector2(0, 0), Vector2(25, 11), 0.8, 4.0, "up", 0)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.x = - 1
		bullet._cast_bullet(Vector2(180, 200), Vector2(0, 0), Vector2(25, 11), 0.8, 4.0, "up", 0)
		yield(get_tree().create_timer(0.4, false), "timeout")

func _bone_slams():
	for i in 5:
		var bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(14, 11), 0.1, 0.0, "right", 300)
		bullet.position.x = 0
		bullet.position.y = 50
		
		yield(get_tree().create_timer(0.1, false), "timeout")
		tween.interpolate_property(bullet.get_child(0), "rect_size:x", 14, 180, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(1.0, false), "timeout")
		if i < 4:
			$Impact.play()
			camera.add_trauma(0.4)
			bullet._blue()
			tween.interpolate_property(bullet, "position:y", bullet.position.y, bullet.position.y + 200, 1.4, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()
			yield(get_tree().create_timer(1.5, false), "timeout")
			remove_child(bullet)
			yield(get_tree().create_timer(0.55, false), "timeout")
		if i == 4:
			_remove_assets()
			camera._flash_dark(0.5)
			yield(get_tree().create_timer(0.5, false), "timeout")
			_bone_jumps()
	
func _bone_swipes():
	for i in 13:
		var bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 180), Vector2(0, 0), Vector2(10, 20), 1.0, 4.5, "right", 180)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(180, 180), Vector2(0, 0), Vector2(10, 20), 1.0, 4.5, "left", 0)
		yield(get_tree().create_timer(1.1, false), "timeout")
	
func _blaster_spawns():
	for i in 5:
		var bullet = blaster.instance()
		main.add_child(bullet)
		main.move_child(bullet, 9)
		var x = int(rand_range(0.1, 1.9))
		if x == 0: bullet._cast_blaster(285, - 100, 285, 100, 0, 0, 2.5, 50)
		if x == 1: bullet._cast_blaster(370, - 100, 370, 100, 0, 0, 2.5, 50)
		
		yield(get_tree().create_timer(2.7, false), "timeout")

func _bone_jumps():
	box_main._box_retween(280, 100, box_arena.rect_position.x - 50, box_arena.rect_position.y + 60, 0.4)
	soul.position.x = 320
	soul.position.y = 280
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(0, 100), Vector2(0, 0), Vector2(10, 100), 1.5, 0.6, "right", 280)
	bullet = bone.instance()
	add_child(bullet)
	bullet.scale.y = - 1
	bullet._cast_bullet(Vector2(280, 100), Vector2(0, 0), Vector2(10, 100), 1.5, 0.6, "left", 0)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 7:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 5.8, "right", 280)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(280, 0), Vector2(0, 0), Vector2(10, 55), 1.0, 5.8, "left", 0)
		
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 100), Vector2(0, 0), Vector2(10, 15), 1.0, 5.8, "right", 280)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(280, 100), Vector2(0, 0), Vector2(10, 15), 1.0, 5.8, "left", 0)
		if i < 6: yield(get_tree().create_timer(0.65, false), "timeout")
		if i == 6:
			yield(get_tree().create_timer(0.4, false), "timeout")
			camera._flash_dark(0.5)
			_remove_assets()
			_part_3()
	

func _part_3():
	box_main._box_retween(220, 120, box_arena.rect_position.x + 30, box_arena.rect_position.y, 0.4)
	for i in 20:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0 + i * 12, 0), Vector2(0, 0), Vector2(10, 10), 0.1, 0.0, "right", 300)
		tween.interpolate_property(bullet.get_child(0), "rect_size:y", 10, 110, 5.7, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	for i in 3:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 40), 1.0, 5.0, "right", 220)
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 120), Vector2(0, 0), Vector2(10, 40), 1.0, 5.0, "right", 220)
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 3:
		if i < 2:
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._blue()
			bullet._cast_bullet(Vector2(220, 120), Vector2(0, 0), Vector2(11, 120), 1.0, 5.4, "left", 0)
			yield(get_tree().create_timer(0.3, false), "timeout")
			bullet = bone.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(220, 0), Vector2(0, 0), Vector2(11, 55), 1.0, 5.4, "left", 0)
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(220, 120), Vector2(0, 0), Vector2(11, 30), 1.0, 5.4, "left", 0)
			yield(get_tree().create_timer(0.3, false), "timeout")
		if i == 2:
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._blue()
			bullet._cast_bullet(Vector2(220, 120), Vector2(0, 0), Vector2(11, 120), 1.0, 5.4, "left", 0)
			yield(get_tree().create_timer(0.5, false), "timeout")
			bullet = bone.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(220, 0), Vector2(0, 0), Vector2(11, 35), 1.0, 5.4, "left", 0)
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(220, 120), Vector2(0, 0), Vector2(11, 60), 1.0, 5.4, "left", 0)
			yield(get_tree().create_timer(0.3, false), "timeout")
	
	for i in 2:
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2( - 40, 120), Vector2(0, 0), Vector2(10, 20), 0.8, 5.6, "right", 220)
		yield(get_tree().create_timer(0.35, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet._blue()
	bullet._cast_bullet(Vector2(110, 0), Vector2(0, 0), Vector2(10, 120), 1.0, 0.0, "right", 300)
	for i in 5:
		bullet = bone.instance()
		add_child(bullet)
		bullet._blue()
		bullet._cast_bullet(Vector2(110 - (i + 1) * 12, 0), Vector2(0, 0), Vector2(10, 120), 1.0, 0.0, "right", 300)
		bullet = bone.instance()
		add_child(bullet)
		bullet._blue()
		bullet._cast_bullet(Vector2(110 + (i + 1) * 12, 0), Vector2(0, 0), Vector2(10, 120), 1.0, 0.0, "right", 300)
		yield(get_tree().create_timer(0.1, false), "timeout")
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	_remove_assets()
	camera._flash_dark(0.6)
	_part_4()

func _part_4():
	is_red = true
	is_blue_down = false
	
	yield(get_tree().create_timer(0.9, false), "timeout")
	for i in 18:
		bullet = bone.instance()
		add_child(bullet)
		var x = int(rand_range(0.1, 3.9))
		if x == 0: bullet._blue()
		if x == 1: bullet._orange()
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 120), Vector2(0, 0), Vector2(10, 60), 1.0, 2.0, "right", 220)
		bullet = bone.instance()
		add_child(bullet)
		x = int(rand_range(0.1, 3.9))
		if x == 0: bullet._blue()
		if x == 1: bullet._orange()
		bullet._cast_bullet(Vector2(220, 0), Vector2(0, 0), Vector2(10, 60), 1.0, 2.0, "left", 0)
		
		bullet = pellet.instance()
		add_child(bullet)
		bullet._cast_bullet(0, 15, 3.0, "right", 220)
		bullet = pellet.instance()
		add_child(bullet)
		bullet._cast_bullet(220, 105, 3.0, "left", 0)
		
		if i % 3 == 0:
			blast = blaster.instance()
			main.add_child(blast)
			blast._cast_blaster_without_rotation(Vector2(rand_range(200, 440), - 100), Vector2(rand_range(200, 440), rand_range(100, 150)), 1.0, 45)
			can_lookat = true
		yield(get_tree().create_timer(0.9, false), "timeout")
	
	main._return_to_selection()

func _remove_assets():
	for i in get_children():
		if i.get_index() > 2:
			self.remove_child(i)
