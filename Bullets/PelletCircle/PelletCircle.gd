extends Node2D

var bullet
var pellet = preload("res://Bullets/Pellet/Pellet.tscn")
var tween = Tween.new()

var value = 1.0

func _ready():
	add_child(tween)

var deltavar = 0.0

func _process(delta):
	deltavar = delta

func _cast_circle(distance, bulletSpeed, type, timeUntilSpawn, timeUntilClose, amt: int = 26):
	for i in amt:
		$snd.play()
		bullet = pellet.instance()
		add_child(bullet)
		bullet.scale = Vector2(0.8, 0.8)
		var pos_x = cos(value) * distance
		var pos_y = sin(value) * distance
		bullet.position = Vector2(pos_x, pos_y)
		value -= PI * 2 / amt
		
		bullet.look_at(position)
		bullet.specrotation = bullet.rotation
		if type == "blue": bullet._blue()
		if type == "orange": bullet._orange()
		
		yield(get_tree().create_timer(timeUntilSpawn, false), "timeout")
	yield(get_tree().create_timer(timeUntilClose, false), "timeout")
	
	_move_bullets(bulletSpeed)

func _cast_holeCircle(distance, bulletSpeed, type, startRot, rot, timeUntilClose):
	
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	for i in 26:
		bullet = pellet.instance()
		add_child(bullet)
		bullet.scale = Vector2(0.8, 0.8)
		var pos_x = cos(value) * distance
		var pos_y = sin(value) * distance
		bullet.position = Vector2(pos_x, pos_y)
		value -= 0.2
		
		bullet.look_at(position)
		bullet.specrotation = bullet.rotation
		if type == "blue": bullet._blue()
		if type == "orange": bullet._orange()
	
	tween.interpolate_property(self, "rotation_degrees", startRot, startRot + rot, timeUntilClose, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	_move_bullets_elim(timeUntilClose)
	

func _cast_dodgeCircle(distance, bulletSpeed, type, timeUntilSpawn, timeUntilClose):
	for i in 6:
		$snd.play()
		bullet = pellet.instance()
		add_child(bullet)
		var pos_x = cos(value) * distance
		var pos_y = sin(value) * distance
		bullet.position = Vector2(pos_x, pos_y)
		value -= PI / 3
		
		bullet.look_at(position)
		bullet.specrotation = bullet.rotation
		if type == "blue": bullet._blue()
		if type == "orange": bullet._orange()
		
		yield(get_tree().create_timer(timeUntilSpawn, false), "timeout")
	yield(get_tree().create_timer(timeUntilClose, false), "timeout")
	
	
	_move_bullets(bulletSpeed)

func _move_bullets(bulletSpeed):
	var currentspeed = 0.0
	for i in 140:
		if currentspeed < bulletSpeed: currentspeed += 0.65 * deltavar * 10
		if currentspeed >= bulletSpeed: currentspeed = bulletSpeed
		for j in get_children():
			if j.get_index() > 1:
				_moveToAngle(j, j.specrotation, currentspeed)
				if i == 100:
					tween.interpolate_property(j, "modulate:a", 1, 0, 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
					tween.start()
		yield(get_tree().create_timer(0.016, false), "timeout")
		
	
	queue_free()

func _move_bullets_elim(time):
	for i in get_children():
		if i.get_index() > 1:
			tween.interpolate_property(i, "position", i.position, Vector2(0, 0), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
	
	yield(get_tree().create_timer(time, false), "timeout")
	queue_free()
	
func _moveToAngle(object, angle, speed):
	var dir = Vector2(cos(angle), sin(angle))
	object.position += dir * speed
