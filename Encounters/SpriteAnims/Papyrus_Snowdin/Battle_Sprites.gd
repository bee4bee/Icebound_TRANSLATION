extends Node2D


var animvar = 0.6

export var addition = 0.09

var idleanimvar = 0.0

func _ready():
	pass

func _process(delta):
	pass

func _show_idle():
	$Idle.show()
	$Battle.hide()
	
func _show_battle():
	$Battle.show()
	$Idle.hide()

func _shake_to_idle():
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 1
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x -= 2
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 3
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x -= 4
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 2
	_show_idle()
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Idle, "scale:y", 0.75, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Idle, "scale:x", 1.3, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _shake_to_battle():
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 1
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x -= 2
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 3
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x -= 4
	yield(get_tree().create_timer(0.07, false), "timeout")
	position.x += 2
	_show_battle()
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Battle, "scale:y", 0.65, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Battle, "scale:x", 1.4, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _emit():
	$Particles2D.emitting = true
	$sparks.play()
