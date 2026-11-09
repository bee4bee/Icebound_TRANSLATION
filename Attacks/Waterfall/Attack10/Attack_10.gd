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


var blaster = preload("res://Bullets/Blaster/Blaster.tscn")

var bonewall = preload("res://Bullets/BoneWall/Bone_Wall.tscn")
var pelletcircle = preload("res://Bullets/PelletCircle/PelletCircle.tscn")

var bullet
var blast
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

func _ready():
	add_child(tween)
	box_main._box_retween(210, 210, box_arena.rect_position.x - 5, box_arena.rect_position.y - 55, 1.0)
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

func _attack():
	_bone_sides()
	_box_rotations()
	for i in 2:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(210, 0), Vector2(0, 0), Vector2(10, 90), 1.0, 4.0, "left", - 20)
		
		yield(get_tree().create_timer(1.0, false), "timeout")
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(90, 10), 1.0, 4.0, "down", 230)
		
		yield(get_tree().create_timer(1.0, false), "timeout")
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 210), Vector2(0, 0), Vector2(10, 90), 1.0, 4.0, "right", 230)
		
		yield(get_tree().create_timer(1.0, false), "timeout")
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.x = - 1
		bullet._cast_bullet(Vector2(210, 210), Vector2(0, 0), Vector2(90, 10), 1.0, 4.0, "up", - 20)
		
		
		yield(get_tree().create_timer(1.0, false), "timeout")
	
	_pellet_circles()
	_blaster_spawns()
	
func _bone_sides():
	for i in 200:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 30), 0.8, 4.0, "right", 210)
		
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(210, 210), Vector2(0, 0), Vector2(10, 30), 0.8, 4.0, "left", 0)
		
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(0, 210), Vector2(0, 0), Vector2(30, 10), 0.8, 4.0, "up", 0)
		
		bullet = bone.instance()
		add_child(bullet)
		bullet.scale.x = - 1
		bullet._cast_bullet(Vector2(210, 0), Vector2(0, 0), Vector2(30, 10), 0.8, 4.0, "down", 210)
		
		yield(get_tree().create_timer(0.12, false), "timeout")
	
	yield(get_tree().create_timer(1.2, false), "timeout")
	
	_slam_attack()


func _box_rotations():
	for i in 6:
		tween.interpolate_property(box_arena, "rect_rotation", box_arena.rect_rotation, box_arena.rect_rotation + 90.0, 3.4, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(2.0, false), "timeout")
		if i < 2:
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._blue()
			bullet._cast_bullet(Vector2(0, 210), Vector2(0, 0), Vector2(10, 210), 1.2, 3.0, "right", 230)
			$swipe.play()
		yield(get_tree().create_timer(2.5, false), "timeout")

func _pellet_circles():
	for i in 7:
		bullet = pelletcircle.instance()
		main.add_child(bullet)
		bullet.position = Vector2(320, 280)
		bullet._cast_holeCircle(220, 8.0, "normal", rand_range(0.0, 360.0), 120.0, 2.8)
		yield(get_tree().create_timer(1.6, false), "timeout")

func _blaster_spawns():
	for i in 16:
		blast = blaster.instance()
		main.add_child(blast)
		var x = int(rand_range(0.1, 1.9))
		if x == 0: blast._cast_blaster_without_rotation(Vector2( - 150, rand_range(180, 380)), Vector2(150, rand_range(180, 380)), 0.7, 30)
		if x == 1: blast._cast_blaster_without_rotation(Vector2(800, rand_range(180, 380)), Vector2(460, rand_range(180, 380)), 0.7, 30)
		can_lookat = true
		if i < 11: yield(get_tree().create_timer(0.55, false), "timeout")
		else: yield(get_tree().create_timer(0.4, false), "timeout")
		can_lookat = false
		if i < 11: yield(get_tree().create_timer(0.75, false), "timeout")


func _slam_attack():
	box_arena.rect_rotation = 0.0
	is_red = false
	is_blue_down = true
	soul._blink()
	soul.slam_multiplier = 5.0
	sanssprite._slamDown()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	bullet = bonewall.instance()
	add_child(bullet)
	bullet._cast_wall(600, 320, 0, 500)
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	camera._flash_dark(0.2)
	yield(get_tree().create_timer(0.2, false), "timeout")
	main._return_to_selection()
