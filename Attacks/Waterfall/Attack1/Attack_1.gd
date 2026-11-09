extends Node2D


onready var main = get_node("/root/Battle_Engine")
onready var camera = get_node("/root/Battle_Engine/Camera")
onready var box_arena = get_node("/root/Battle_Engine/BattleBox").get_child(0).get_child(0)
onready var box_main = get_node("/root/Battle_Engine/BattleBox")
onready var sanssprite = get_node("/root/Battle_Engine/Battle_Sprites/Sans")
onready var floweysprite = get_node("/root/Battle_Engine/Battle_Sprites/Flowey")

var bone_preload = preload("res://Bullets/Bone/Bone.tscn")
var bone

var pellet_preload = preload("res://Bullets/Pellet/Pellet.tscn")
var pellet

var blaster_preload = preload("res://Bullets/Blaster/Blaster.tscn")
var blaster

onready var soul = get_node("/root/Battle_Engine/Player_Soul")

var canCastBlaster = true
var bullet
var node = Node2D.new()
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

var canLookAt = false

func _ready():
	PlayerData.didSansDodge = true
	add_child(node)
	add_child(tween)
	
	_attack()

var dvar = 0.0
var bonemid
var canRotate = false

func _process(delta):
	dvar = delta
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()
	
	if canLookAt == true:
		blaster.look_at(soul.position)
		blaster.rotation_degrees -= 90
		yield(get_tree().create_timer(0.3, false), "timeout")
		canLookAt = false
	
	if canRotate: _rotate(bonemid, delta)
	
func _attack():
	
	
	for i in 5:
		bullet = bone_preload.instance()
		node.add_child(bullet)
		bullet._cast_bullet(Vector2(0 + i * 12, 0), Vector2(0, 0), Vector2(10, 150), 1.0, 0.0, "right", 210)
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	bullet = blaster_preload.instance()
	main.add_child(bullet)
	bullet._cast_blaster(soul.global_position.x, - 100, soul.global_position.x, 180, - 45, 0, 2.8, 45)
	
	for i in 4:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet._cast_bullet(Vector2(200, 0), Vector2(0, 0), Vector2(10, 70), 0.7, 4.5, "left", - 10)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2(0, 150), Vector2(0, 0), Vector2(10, 70), 0.7, 4.5, "right", 210)
		yield(get_tree().create_timer(0.55, false), "timeout")
	
	for i in node.get_children():
		i._blue()
		tween.interpolate_property(i, "position:x", i.position.x, i.position.x + 210, 0.9, Tween.TRANS_QUINT, Tween.EASE_IN)
		tween.start()
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	box_main._box_retween(130, 130, box_arena.rect_position.x + 230, box_arena.rect_position.y + 20, 1.5)
	tween.interpolate_property(box_arena, "rect_rotation", 0.0, 360.0, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(1.15, false), "timeout")
	is_red = false
	is_blue_down = true
	
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 3:
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._cast_bullet(Vector2( - 10, 130), Vector2(0, 0), Vector2(10, 35), 0.4, 3.8, "right", 170)
		bullet = bone_preload.instance()
		add_child(bullet)
		bullet.scale.y = - 1
		bullet._blue()
		bullet._cast_bullet(Vector2(170, 130), Vector2(0, 0), Vector2(10, 130), 0.6, 3.8, "left", - 10)
		yield(get_tree().create_timer(1.1, false), "timeout")
	
	bonemid = bone_preload.instance()
	add_child(bonemid)
	bonemid._cast_bullet(Vector2(60, 0), Vector2(0, 0), Vector2(10, 130), 1.6, 0.0, "right", 300)
	
	is_red = true
	is_blue_down = false
	
	yield(get_tree().create_timer(1.1, false), "timeout")
	
	_rotate(bonemid, dvar)
	
	for i in 10:
		blaster = blaster_preload.instance()
		main.add_child(blaster)
		blaster._cast_blaster_without_rotation(Vector2(800, soul.global_position.y), Vector2(570, soul.global_position.y), 1.5, 30)
		canLookAt = true
		yield(get_tree().create_timer(0.75, false), "timeout")
		
		
		
		yield(get_tree().create_timer(0.15, false), "timeout")
	
	
	box_arena.rect_rotation = 0.0
	main._return_to_selection()


func _rotate(elem, delta):
	for i in 10000:
		elem.get_child(0).rect_rotation += 210 * delta
		box_arena.rect_rotation -= 85 * delta
		box_arena.rect_position.x -= 80 * delta
		yield(get_tree().create_timer(get_process_delta_time(), false), "timeout")
