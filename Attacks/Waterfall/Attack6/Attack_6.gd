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
var vine = preload("res://Bullets/Vine/Vine.tscn")

var timer_pelletSwarmSpawn = Timer.new()
var timer_untilBoneSpawns = Timer.new()
var timer_boneSpawn = Timer.new()

var bullet
var tween = Tween.new()

func _ready():
	
	_cast_vines()
	
	add_child(tween)
	timer_pelletSwarmSpawn.wait_time = 1.0
	timer_pelletSwarmSpawn.one_shot = false
	timer_pelletSwarmSpawn.connect("timeout", self, "_cast_pellet_swarm")
	main.add_child(timer_pelletSwarmSpawn)
	timer_pelletSwarmSpawn.start(0)
	
	timer_untilBoneSpawns.wait_time = 8.0
	timer_untilBoneSpawns.one_shot = true
	timer_untilBoneSpawns.connect("timeout", self, "_cast_bones")
	main.add_child(timer_untilBoneSpawns)
	timer_untilBoneSpawns.start(0)
	
	timer_boneSpawn.wait_time = 1.4
	timer_boneSpawn.one_shot = false
	main.add_child(timer_boneSpawn)
	
	box_main._box_retween(200, 200, - 25, - 50, 1.0)

func _process(delta):
	soul._red()
	print(timer_pelletSwarmSpawn.time_left)


func _cast_pellet_swarm():
	for i in 3:
		var ex = int(rand_range(0.1, 3.9))
		var firstpos = Vector2(0, 0)
		
		var colorgen = rand_range(0.1, 9.9)
		bullet = pellet.instance()
		if colorgen >= 8.2: bullet._orange()
		add_child(bullet)
		if ex == 0: bullet.position = Vector2( - 10, - 10)
		if ex == 1: bullet.position = Vector2(210, - 10)
		if ex == 2: bullet.position = Vector2( - 10, 210)
		if ex == 3: bullet.position = Vector2(210, 210)
		
		tween.interpolate_property(
			bullet, "global_position", 
			bullet.global_position, soul.global_position + (soul.global_position - bullet.global_position) * 25, 24.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
		$snd.play()
		yield(get_tree().create_timer(0.08, false), "timeout")

func _cast_bones():
	for i in 10:
		bullet = bone.instance()
		add_child(bullet)
		
		var ex = int(rand_range(0.1, 1.9))
	
		if ex == 0:
			bullet.rotation_degrees = 180
			bullet._cast_bullet(
				Vector2(10, 200), Vector2(0, 0), Vector2(10, 65), 
				1.0, 0, "right", 300
			)
			tween.interpolate_property(
				bullet, "position:x", 
				bullet.position.x, bullet.position.x + 300, 1.4, 
				Tween.TRANS_QUINT, Tween.EASE_IN
			)
			tween.start()
		
		if ex == 1:
			bullet._cast_bullet(
				Vector2(190, 0), Vector2(0, 0), Vector2(10, 65), 
				1.0, 0, "left", - 100
			)
			tween.interpolate_property(
				bullet, "position:x", 
				bullet.position.x, bullet.position.x - 300, 1.4, 
				Tween.TRANS_QUINT, Tween.EASE_IN
			)
			tween.start()
		
		yield(get_tree().create_timer(0.95, false), "timeout")
	
	yield(get_tree().create_timer(0.65, false), "timeout")
	main._return_to_selection()

func _cast_vines():
	bullet = vine.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(25, - 25), 0, 700)
	
	yield(get_tree().create_timer(0.15, false), "timeout")
	bullet = vine.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(175, 225), 180, 700)
	
	yield(get_tree().create_timer(0.15, false), "timeout")
	bullet = vine.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2( - 25, 25), - 90, 700)
	
	yield(get_tree().create_timer(0.15, false), "timeout")
	bullet = vine.instance()
	add_child(bullet)
	bullet._cast_vine(Vector2(225, 175), 90, 700)
