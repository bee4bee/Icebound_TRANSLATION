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

var warn = preload("res://Bullets/Warn/Warn.tscn")
var bullet
var tween = Tween.new()

var is_red = true
var is_blue_down = false
var is_blue_up = false

var can_rotate = false
var can_spawn_pellets = false

func _ready():
	add_child(tween)
	box_main._box_retween(160, 160, - 10, - 10, 1.5)
	_attack()

func _process(delta):
	if is_red == true:
		soul._red()
		
	if is_blue_down == true:
		soul._blue_down()
		
	if is_blue_up == true:
		soul._blue_up()
	
	if can_rotate:
		for i in $spinBone.get_children():
			i.get_child(0).rect_rotation += 1 * delta * 40
	
	if can_spawn_pellets:
		can_spawn_pellets = false
		_pellets()

func _attack():
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(soul.position.x, - 200, soul.position.x, 230, - 30, 0, 3, 20)
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 200, soul.position.y, 150, soul.position.y, - 60, - 90, 3, 20)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	is_red = false
	is_blue_down = true
	yield(get_tree().create_timer(0.3, false), "timeout")
	
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 200, 360, 150, 360, - 60, - 90, 2.2, 20)
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(840, 240, 490, 240, 60, 90, 2.2, 20)
	
	bullet = bone.instance()
	add_child(bullet)
	bullet.rotation_degrees = 180
	bullet._blue()
	bullet._cast_bullet(
		Vector2(0, 160), Vector2(0, 0), Vector2(10, 160), 
		1.2, 3, "right", 200
	)
	
	yield(get_tree().create_timer(1.2, false), "timeout")
	is_blue_down = false
	is_blue_up = true
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	for i in 4:
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2( - 10, 0), Vector2(0, 0), Vector2(10, 25), 
			1.0, 5, "right", 200
		)
		bullet = bone.instance()
		add_child(bullet)
		bullet._cast_bullet(
			Vector2(160, 0), Vector2(0, 0), Vector2(10, 25), 
			1.0, 5, "left", - 40
		)
		yield(get_tree().create_timer(0.6, false), "timeout")
	
	yield(get_tree().create_timer(0.12, false), "timeout")
	is_blue_up = false
	is_red = true
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	bullet = warn.instance()
	add_child(bullet)
	bullet._cast(Vector2(75, 75))
	
	yield(get_tree().create_timer(0.7, false), "timeout")
	
	bullet = bone.instance()
	$spinBone.add_child(bullet)
	bullet.rotation_degrees = - 90
	bullet._cast_bullet(Vector2( - 30, 80), Vector2(0, 0), Vector2(10, 220), 1.5, 0, "right", 300)
	bullet = bone.instance()
	$spinBone.add_child(bullet)
	bullet._cast_bullet(Vector2(80, - 30), Vector2(0, 0), Vector2(10, 220), 1.5, 0, "right", 400)
	
	yield(get_tree().create_timer(0.6, false), "timeout")
	can_rotate = true
	can_spawn_pellets = true
	
	for i in 6:
		bullet = bone.instance()
		add_child(bullet)
		
		bullet.rotation_degrees = 180
		if i % 2 == 1:
			bullet._cast_bullet(
				Vector2( - 20, 160), Vector2(0, 0), Vector2(10, 160), 
				1.0, 3.5, "right", 200
			)
			bullet._blue()
		if i % 2 == 0:
			bullet._cast_bullet(
				Vector2(180, 160), Vector2(0, 0), Vector2(10, 160), 
				1.0, 3.5, "left", - 40
			)
			bullet._orange()
		yield(get_tree().create_timer(1.5, false), "timeout")
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	for i in $spinBone.get_children():
		tween.interpolate_property(
			i.get_child(0), "rect_scale", 
			Vector2(1, 1), Vector2(0, 0), 0.6, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		i.get_child(1).scale = Vector2(0, 0)
		tween.start()
	
	yield(get_tree().create_timer(0.4, false), "timeout")
	can_rotate = false
	$spinBone.queue_free()
	yield(get_tree().create_timer(0.2, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet.rotation_degrees = - 90
	bullet._cast_bullet(
		Vector2(0, 0), Vector2(0, 0), Vector2(10, 160), 
		2.0, 0.0, "left", - 50
	)
	tween.interpolate_property(
		bullet, "position:y", 
		0, 40, 1.0, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(320, - 100, 320, 160, 30, 0, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(740, - 100, 440, 200, 70, 45, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(740, 310, 460, 310, 120, 90, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(740, 580, 440, 420, 180, 135, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster(320, 580, 320, 460, 210, 180, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 100, 580, 200, 420, 180, 225, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 100, 310, 180, 310, 300, 270, 2.0, 25)
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	bullet = blaster.instance()
	main.add_child(bullet)
	bullet._cast_blaster( - 100, - 100, 200, 200, 350, 315, 2.0, 25)
	
	yield(get_tree().create_timer(1.1, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet.rotation_degrees = 90
	bullet._cast_bullet(Vector2(160, 160), Vector2(0, 0), Vector2(10, 100), 1.5, 0, "right", 200)
	tween.interpolate_property(bullet, "position:y", 160, - 10, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	bullet = bone.instance()
	add_child(bullet)
	bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, 160), 1.2, 0.0, "right", 200)
	bullet._blue()
	tween.interpolate_property(
		bullet, "position:x", 
		0, 210, 1.8, 
		Tween.TRANS_QUINT, Tween.EASE_IN
	)
	tween.start()
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	bullet = bone.instance()
	add_child(bullet)
	bullet.rotation_degrees = - 90
	bullet._cast_bullet(
		Vector2(0, 0), Vector2(0, 0), Vector2(10, 75), 
		1.5, 0, "right", 200
	)
	tween.interpolate_property(
		bullet, "position:y", 
		0, 170, 3.0, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()
	yield(get_tree().create_timer(2.1, false), "timeout")
	
	main._return_to_selection()
	
func _pellets():
	for i in 19:
		$pellet.play()
		bullet = pellet.instance()
		add_child(bullet)
		bullet.position = Vector2(80, 80)
		tween.interpolate_property(
			bullet, "position", 
			bullet.position, soul.global_position + (soul.global_position - bullet.global_position) * 25, 21.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
		yield(get_tree().create_timer(0.5, false), "timeout")
	
