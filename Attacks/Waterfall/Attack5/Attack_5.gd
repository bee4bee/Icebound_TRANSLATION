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



var bone_blast_preload = preload("res://Bullets/BoneBlast/BoneBlast.tscn")

var index = 0.0
var bullet

var colorbone1

var tween = Tween.new()

func _ready():
	add_child(tween)
	box_main._box_retween(280, 100, - 125, 10, 1.0)
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
	is_blue_down = true
	is_red = false
	
	for i in 5:
		bullet = bone_preload.instance()
		main.add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(soul.position.x + 2, 200), Vector2(0, 0), Vector2(10, 60), 1.0, 0, "left", - 600)
		tween.interpolate_property(
			bullet, "position:y", 
			bullet.position.y, bullet.position.y + 400, 0.9, 
			Tween.TRANS_QUINT, Tween.EASE_IN
		)
		tween.start()
		if i == 3:
			bullet = bone_preload.instance()
			main.add_child(bullet)
			bullet.rotation_degrees = 90
			bullet._cast_bullet(
				Vector2(100, soul.position.y), Vector2(0, 0), Vector2(10, 80), 
				1.0, 0, "right", 800
			)
			tween.interpolate_property(
				bullet, "position:x", 
				bullet.position.x, bullet.position.y + 800, 1.0, 
				Tween.TRANS_QUINT, Tween.EASE_IN
			)
			tween.start()
		yield(get_tree().create_timer(0.25, false), "timeout")
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	bullet = bone_preload.instance()
	main.add_child(bullet)
	bullet.rotation_degrees = - 90
	bullet._cast_bullet(
		Vector2(380, soul.position.y), Vector2(0, 0), Vector2(10, 80), 
		1.0, 0, "left", - 200
	)
	tween.interpolate_property(
		bullet, "position:x", 
		bullet.position.x, bullet.position.y - 800, 1.0, 
		Tween.TRANS_QUINT, Tween.EASE_IN
	)
	tween.start()
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	bullet = bone_blast_preload.instance()
	main.add_child(bullet)
	bullet._cast_boneblast(Vector2(160, 280), 5)
	
	bullet = bone_blast_preload.instance()
	main.add_child(bullet)
	bullet._cast_boneblast(Vector2(360, 280), 5)
	
	yield(get_tree().create_timer(1.45, false), "timeout")
	is_blue_up = true
	is_blue_down = false
	
	
	soul._blink()
	box_main._box_retween(220, 130, - 35, 0, 0.6)
	yield(get_tree().create_timer(0.8, false), "timeout")
	_move_box()
	
	for i in 7:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180.0
		bullet._cast_bullet(
			Vector2(0, 125), Vector2(0, 0), Vector2(10, 70), 0.8, 
			4.5, "right", 300
		)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2( - 10, 5), Vector2(0, 0), Vector2(10, 15), 0.8, 
			4.5, "right", 300
		)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180.0
		bullet._cast_bullet(
			Vector2(220, 125), Vector2(0, 0), Vector2(10, 70), 0.8, 
			4.5, "left", - 50
		)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2(210, 5), Vector2(0, 0), Vector2(10, 15), 0.8, 
			4.5, "left", - 50
		)
		if i == 3:
			_color_bone()
		yield(get_tree().create_timer(0.65, false), "timeout")
	
	is_red = true
	is_blue_up = false
	soul._blink()
	
	
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(110, - 35), 0, 35)
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(30, - 35), 0, 35)
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(190, - 35), 0, 35)
	bullet = blaster_preload.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 100, soul.position.y + 20, 600, soul.position.y + 20, 90, 90, 2.5, 35)
	
	yield(get_tree().create_timer(1.5, false), "timeout")
	_part_2()

func _part_2():
	_spawn_bones_margins()
	_spawn_bones_inner()

func _move_box():
	tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x + 140, 4.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _color_bone():
	colorbone1 = bone_preload.instance()
	add_child(colorbone1)
	colorbone1._cast_bullet(
		Vector2(0, 5), Vector2(220, 0), Vector2(10, 130), 1.5, 
		0.0, "left", - 260
	)
	colorbone1._blue()
	yield(get_tree().create_timer(1.25, false), "timeout")
	tween.interpolate_property(
		colorbone1, "position:x", 
		0, - 260, 1.5, 
		Tween.TRANS_QUINT, Tween.EASE_IN
	)
	tween.start()


func _spawn_bones_margins():
	for i in 300:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 30), 0.5, 3.5, "right", 230)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(230, 130), Vector2(0, 0), Vector2(10, 30), 0.5, 3.5, "left", - 10)
		
		yield(get_tree().create_timer(0.1, false), "timeout")

func _spawn_bones_inner():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(box_arena, "rect_position:x", box_arena.rect_position.x, box_arena.rect_position.x - 150, 
	25.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	for i in 10:
		if i % 4 == 0:
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet._cast_bullet(Vector2( - 10, 30), Vector2(0, 0), Vector2(10, 70), 1.0, 3.2, "right", 230)
			
			bullet = bone_preload.instance()
			add_child(bullet)
			bullet._blue()
			bullet._cast_bullet(Vector2(230, 30), Vector2(0, 0), Vector2(10, 70), 1.0, 3.2, "left", - 10)
			$swipe.play()
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2( - 10, 30), Vector2(0, 0), Vector2(10, 35), 0.8, 1.5, "right", 230)
	
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._cast_bullet(Vector2(230, 100), Vector2(0, 0), Vector2(10, 35), 0.8, 1.5, "left", - 10)
	
		yield(get_tree().create_timer(1.2, false), "timeout")
	yield(get_tree().create_timer(0.2, false), "timeout")
	main._return_to_selection()
