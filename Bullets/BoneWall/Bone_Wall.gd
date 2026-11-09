extends Node2D


func _ready():
	pass

var timer = 0.0
var timerCap = 0.0
var timeCast = 0.0
var p1 = 0.0
var p2 = 0.0

var canSpawn = true
var canRemove = true

func _process(delta):
	timer += 0.8 * delta * 40
	if timer >= 15 and canSpawn == true:
		canSpawn = false
		$Barrier.hide()
		var tween = Tween.new()
		add_child(tween)
	
		tween.interpolate_property(self, "global_position:y", p1, p2, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		$rise.play()
	
	if timer >= timerCap and canRemove == true:
		canRemove = false
		_remove_wall()
	
	if timer >= timerCap + 45:
		get_parent().remove_child(self)
	

func _cast_wall(posStart, posEnd, rot, duration):
	rotation_degrees = rot
	
	$startup.play()
	global_position.y = posStart
	
	
	
	
	
	
	
	
	
	$Barrier.global_position.y = posEnd
	timerCap = duration
	p1 = posStart
	p2 = posEnd

func _remove_wall():
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		self, "position:y", 
		p2, p1, 1.0, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
