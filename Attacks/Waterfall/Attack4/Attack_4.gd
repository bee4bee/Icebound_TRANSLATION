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

var bonewall_preload = preload("res://Bullets/BoneWall/Bone_Wall.tscn")

var platformpink_preload = preload("res://Bullets/Platform_Pink/Platform_Pink.tscn")

var index = 0.0

var is_red = false
var is_blue_down = true
var is_blue_up = false

func _ready():
	box_main._box_retween(265, 150, - 55, 0, 1.0)
	
	is_blue_down = true
	
	platform = platformpink_preload.instance()
	add_child(platform)
	platform._cast_platform(
		Vector2(450, 100), Vector2(200, 100), 
		1.2, 0, 1000
	)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	bullet = bonewall_preload.instance()
	add_child(bullet)
	bullet._cast_wall(600, 360, 0, 500)
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	bullet = bonewall_preload.instance()
	add_child(bullet)
	bullet._cast_wall(100, 260, 180, 500)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	for i in range(0, 1):
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.rotation_degrees = 180
		bullet._orange()
		bullet._cast_bullet(
			Vector2(200, 160), Vector2( - 170, 0), Vector2(10, 120), 
			2.5, 4.0, "left", - 200
		)
		yield(get_tree().create_timer(0.4, false), "timeout")
	
	
		
	bullet = blaster_preload.instance()
	main.add_child(bullet)
	bullet._cast_blaster(
		- 50, 330, 125, 330, 
		- 70, - 90, 1.5, 25
	)
	
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	
	yield(get_tree().create_timer(0.85, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._orange()
	bullet._cast_bullet(
		Vector2(100, 160), Vector2(130, 0), Vector2(10, 120), 
		1.5, 4.0, "right", 800
	)
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	bones()
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	bullet = bone_preload.instance()
	add_child(bullet)
	bullet._blue()
	bullet._cast_bullet(
		Vector2(75, - 10), Vector2( - 105, 0), Vector2(10, 120), 
		1.5, 4.0, "right", 800
	)
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	bullet = blaster_preload.instance()
	main.add_child(bullet)
	bullet._cast_blaster(
		- 50, 280, 125, 280, 
		- 70, - 90, 1.5, 45
	)
	
	yield(get_tree().create_timer(1.2, false), "timeout")
	
	platform._drop_platform()
	is_red = true
	is_blue_down = false
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	boneleft = bone_preload.instance()
	add_child(boneleft)
	boneleft._cast_bullet(
		Vector2(180, 0), Vector2( - 180, 0), Vector2(10, 130), 
		2.5, 0.0, "left", - 200
	)
	
	boneright = bone_preload.instance()
	add_child(boneright)
	boneright.rotation_degrees = 180
	boneright._cast_bullet(
		Vector2(80, 150), Vector2( - 185, 0), Vector2(10, 130), 
		2.5, 0.0, "right", 465
	)
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	boneleft._blue()
	boneright._orange()
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		boneleft, "position:x", 
		boneleft.position.x, boneleft.position.x + 225, 2.0, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	
	tween.interpolate_property(
		boneright, "position:x", 
		boneright.position.x, boneright.position.x - 225, 3.0, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	
	tween.start()
	
	yield(get_tree().create_timer(2.6, false), "timeout")
	
	main._return_to_selection()

func bones():
	for i in range(0, 9):
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._rotate_bone(200, 180, 1.0)
		bullet._cast_bullet(
			Vector2(265, 160), Vector2(0, 0), Vector2(10, 70), 
			0.5, 5.0, "left", - 200
		)
		
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._rotate_bone( - 20, 0, 1.0)
		bullet._cast_bullet(
			Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 70), 
			0.5, 5.0, "right", 800
		)
		yield(get_tree().create_timer(1.05, false), "timeout")

var platform
var bullet

var boneleft
var boneright

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()

func _physics_process(delta):
	index += 1
	platform.position.x += cos(index / 55) * 5 / 3
