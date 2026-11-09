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
var boneblast = preload("res://Bullets/BoneBlast/BoneBlast.tscn")
var pelletcircle = preload("res://Bullets/PelletCircle/PelletCircle.tscn")

var bullet
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

func _ready():
	add_child(tween)
	box_main._box_retween(100, 100, box_arena.rect_position.x + 40, box_arena.rect_position.y + 20, 1.0)
	_attack()

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()

func _attack():
	is_red = true
	
	for i in 8:
		bullet = pelletcircle.instance()
		main.add_child(bullet)
		bullet.position = Vector2(320, 300)
		var x = int(rand_range(0.1, 1.9))
		if x == 0: bullet._cast_circle(85, 9.5, "blue", 0.005, 0.2)
		else: bullet._cast_circle(90, 9.5, "orange", 0.005, 0.2)
		yield(get_tree().create_timer(0.78, false), "timeout")
	
	yield(get_tree().create_timer(1.1, false), "timeout")
	
	is_red = false
	is_blue_down = true
	soul._blink()
	
	box_main._box_retween(220, 120, box_arena.rect_position.x - 60, box_arena.rect_position.y, 1.0)
	_middle_circles()
	for i in 18:
		
		if i < 9:
			bullet = bone.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 70), 1.0, 1.4, "right", 240)
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(220, 120), Vector2(0, 0), Vector2(10, 40), 1.0, 1.4, "left", - 20)
		else:
			bullet = bone.instance()
			add_child(bullet)
			bullet._cast_bullet(Vector2(220, 0), Vector2(0, 0), Vector2(10, 70), 1.0, 1.4, "left", - 20)
			bullet = bone.instance()
			add_child(bullet)
			bullet.scale.y = - 1
			bullet._cast_bullet(Vector2(0, 120), Vector2(0, 0), Vector2(10, 40), 1.0, 1.4, "right", 240)
		yield(get_tree().create_timer(1.3, false), "timeout")
	
	yield(get_tree().create_timer(2.8, false), "timeout")
	bullet = boneblast.instance()
	main.add_child(bullet)
	bullet._cast_boneblast(Vector2(320, 120), 5)
	
	is_blue_down = false
	is_red = true
	soul._blink()
	
	_coloredBonesFinal()
	
	for i in 6:
		bullet = pelletcircle.instance()
		main.add_child(bullet)
		bullet.position = soul.position
		bullet.rotation_degrees = rand_range(0.0, 180.0)
		bullet._cast_dodgeCircle(58, 8.0, "normal", 0.15, 0.45)
		yield(get_tree().create_timer(1.4, false), "timeout")
	
	yield(get_tree().create_timer(1.4, false), "timeout")
	main._return_to_selection()
	
func _middle_circles():
	for i in 6:
		bullet = pelletcircle.instance()
		main.add_child(bullet)
		bullet.position = Vector2(320, 300)
		var x = int(rand_range(0.1, 1.9))
		if x == 0: bullet._cast_circle(180, 5.5, "blue", 0.07, 0.3)
		else: bullet._cast_circle(180, 5.5, "orange", 0.07, 0.3)
		yield(get_tree().create_timer(4.5, false), "timeout")

func _coloredBonesFinal():
	yield(get_tree().create_timer(2.5, false), "timeout")
	for i in 3:
		$swipe.play()
		
		bullet = bone.instance()
		add_child(bullet)
		bullet._blue()
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 120), Vector2(0, 0), Vector2(10, 120), 1.0, 4.0, "right", 240)
		tween.interpolate_property(bullet, "rotation_degrees", - 20.0, 0.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(1.3, false), "timeout")
