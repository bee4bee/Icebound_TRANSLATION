extends Node2D


onready var main = get_node("/root/Battle_Engine")
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

var index = 0.0
var bullet

var tween = Tween.new()


func _ready():
	soul._blink()
	add_child(tween)
	tween.interpolate_property(
		sanssprite, "position:x", 
		sanssprite.position.x, sanssprite.position.x - 130.0, 1.5, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.interpolate_property(
		floweysprite, "position:x", 
		floweysprite.position.x, floweysprite.position.x - 90.0, 1.5, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
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
	soul._red()
	box_main._box_retween(250, 120, - 50, 0, 1.0)
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(0, 0), - 30, 250)
		
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(240, 0), 30, 250)
	
	for i in 22:
		if i > 3:
			bullet = pellet_preload.instance()
			add_child(bullet)
			bullet.scale = Vector2(0.8, 0.8)
			var n = int(rand_range(0.0, 1.9))
			var dir = ""
			var margin = 0.0
			if n == 0:
				dir = "right"
				margin = 250
			if n == 1:
				dir = "left"
				margin = 0
			bullet._cast_bullet(n * 250, rand_range(10, 110), 3.5, dir, margin)
		if (i + 1) % 4 == 0:
			bullet = vine_preload.instance()
			add_child(bullet)
			bullet._cast_vine(Vector2(soul.position.x - 210, - 16.0), 0.0, 25)
		yield(get_tree().create_timer(0.28, false), "timeout")
	
	bullet = vine_preload.instance()
	main.add_child(bullet)
	bullet._cast_vine(Vector2(40, - 10), 0, 80)
		
	bullet = vine_preload.instance()
	main.add_child(bullet)
	bullet._cast_vine(Vector2(600, - 10), 0, 80)
	
	bullet = vine_preload.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2( - 16, 110), - 90.0, 340)
	camera._rotate_camera(180, 1.5)
	box_main._box_retween(300, 120, - 75, 0, 1.0)
	
	yield(get_tree().create_timer(0.35, false), "timeout")
	
	for i in 12:
		if i % 2 == 0:
			for j in 5:
				bullet = pellet_preload.instance()
				add_child(bullet)
				bullet.scale = Vector2(0.8, 0.8)
				bullet._cast_bullet(0, 15 + j * 20, 3.7, "right", 300)
				bullet._blue()
		
		bullet = vine_preload.instance()
		add_child(bullet)
		var xor = int(rand_range(0.0, 1.9))
		if xor == 0: bullet._cast_vine(Vector2(soul.position.x - 180, - 16), 0.0, 25)
		if xor == 1: bullet._cast_vine(Vector2(soul.position.x - 180, 136), 180.0, 25)
		
		yield(get_tree().create_timer(0.75, false), "timeout")
	
	tween.interpolate_property(sanssprite, "position:x", sanssprite.position.x, sanssprite.position.x + 130.0, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(floweysprite, "position:x", floweysprite.position.x, floweysprite.position.x + 90.0, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	camera._rotate_camera(0, 1.5)
	main._return_to_selection()
