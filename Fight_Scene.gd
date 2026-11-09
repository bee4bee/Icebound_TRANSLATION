extends Control

onready var meter = $Meter
onready var bar = $Bar
onready var tweenbar1 = $Tween_Bar_1
onready var tweenbar2 = $Tween_Bar_2
onready var tweenmeter = $Tween_Meter
var i = 0
var j = 0
var k = 0
var ref_pos = 0.0

signal animation_finished
signal attack_is_casted(hit_position)

signal enemy_turn_begin(scale_x_finish, pos_x_finish, scale_y_finish, pos_y_finish)

var action_check = false
var attack_can_be_casted = false
var attackCastFirst = false
var poststartinterpolation = false

func _ready():
	
	meter.position.y = 311
	meter.position.x = 360
	bar.position.y = 311
	bar.position.x = - 100
	meter.scale.x = 0
	meter.modulate.a = 0.0

func _process(delta):
	
	i += 40 * delta
	if action_check == true:
		k += 40 * delta
	
	if i > 1 and attackCastFirst == false:
		attackCastFirst = true
		attack_can_be_casted = true
		_start_asset_interpolation()
	
	if i > 20 and poststartinterpolation == false:
		poststartinterpolation = true
		_post_start_asset_interpolation()
	
	if i > 20:
		if Input.is_action_just_pressed("ui_accept") and action_check == false and attack_can_be_casted == true:
			print(1)
			attack_can_be_casted = false
			bar.playing = true
			action_check = true
			_ending_keypress_bar_tween()
			emit_signal("attack_is_casted", bar.position.x)
	if k > 35:
		_remove_asset_interpolation(delta)
	if k > 60:
		k = 0
		
		action_check = false
		attackCastFirst = false
		poststartinterpolation = false
		self.set_process(false)
	
	if bar.position.x > 560 and action_check == false:
		attack_can_be_casted = false
		_remove_asset_interpolation(delta)
		
	if $Slash.frame == 2: $Slash / Hit.play()

func _remove_asset_interpolation(delta):
	j += 75 * delta
	if j > 20:
		tweenbar2.stop_all()
		tweenmeter.remove_all()
		tweenmeter.interpolate_property(meter, "scale:x", meter.scale.x, 0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tweenmeter.interpolate_property(meter, "modulate:a", meter.modulate.a, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tweenmeter.interpolate_property(bar, "modulate:a", bar.modulate.a, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tweenmeter.start()
	
	if j > 35:
		emit_signal("enemy_turn_begin", 150, 200, 150, 0)
		emit_signal("animation_finished")
		
		j = 0
		i = 0
		k = 0
		print(2)
		action_check = false
		attackCastFirst = false
		poststartinterpolation = false
		self.set_process(false)

func _start_asset_interpolation():
	meter.show()
	bar.show()
	bar.playing = false
	bar.frame = 0
	bar.position.x = - 10
	meter.position.x = 330
	bar.modulate.a = 1.0
	
	tweenbar1.remove_all()
	tweenmeter.remove_all()
	tweenbar1.interpolate_property(bar, "position:x", bar.position.x, 50, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenmeter.interpolate_property(meter, "scale:x", meter.scale.x, 1.93, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenmeter.interpolate_property(meter, "modulate:a", meter.modulate.a, 1.0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenmeter.start()
	tweenbar1.start()

func _post_start_asset_interpolation():
	tweenbar1.stop_all()
	tweenbar2.interpolate_property(bar, "position:x", bar.position.x, 590, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenbar2.start()

func _ending_keypress_bar_tween():
	ref_pos = bar.position.x
	tweenbar2.remove_all()
	tweenbar2.interpolate_property(bar, "position:x", bar.position.x, ref_pos + 25, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenbar2.start()
