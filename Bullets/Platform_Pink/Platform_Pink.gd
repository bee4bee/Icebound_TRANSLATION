extends StaticBody2D


func _ready():
	pass

var speed = 0.0
var margin = 0.0
var start_drop = false

var fallspeed = 0.0

func _process(delta):
	position.x += speed * delta * 40
	
	if speed > 0 and position.x > margin: queue_free()
	
	if speed < 0 and position.x < margin: queue_free()
	
	if start_drop == true:
		fallspeed += 0.1 * delta * 40
		position.y += fallspeed
		rotation_degrees += fallspeed / 1.7
		if position.y > 800: get_parent().remove_child(self)

func _cast_platform(posStart, posEnd, duration, motion, elimpos):
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		self, "position", 
		posStart, posEnd, duration, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
	
	speed = motion
	margin = elimpos

func _cast_platform_direct(start, mov, marg):
	position = start
	speed = mov
	margin = marg


func _drop_platform():
	start_drop = true
