extends Node2D


onready var sans = $Sans
onready var flowey = $Flowey

onready var tween = $Tween

var sans_pos = 0.0
var char_move = false
var char_pos = 0
var index = 0

var dmgpos_x = 0.0
var dmgpos_y = 0.0

func _ready():
	pass



func _on_Battle_Engine_attack_start():
	char_move = true
	if not PlayerData.didSansDodge: PlayerData._tempSlowdown(0.3)
	else: PlayerData._tempSlowdown(0.15)
	if char_pos == 0:
		
		tween.interpolate_property(sans, "position:x", sans.position.x, sans.position.x - 185, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(1.05, false), "timeout")
		tween.interpolate_property(sans, "position:x", sans.position.x, sans.position.x + 185, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
	
	if char_pos == 1:
		_flowey_anim_show()
		$Flowey / Animations.play("sink")
		yield(get_tree().create_timer(1.05, false), "timeout")
		$Flowey / Animations.play("rise")
		yield(get_tree().create_timer(0.55, false), "timeout")
		_flowey_anim_hide()
	
	char_move = false

func _on_Menu_player_is_attacking(enemy_position, is_attack_active):
	char_pos = enemy_position

func _flowey_appear():
	_flowey_anim_show()
	$Flowey / Animations.play("rise")
	tween.interpolate_property(sans, "position:x", sans.position.x, sans.position.x - 65, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.6, false), "timeout")
	_flowey_anim_hide()

func _flowey_anim_show():
	$Flowey / Flowey_Body.hide()
	$Flowey / Flowey_Head.hide()
	$Flowey / Animations.show()

func _flowey_anim_hide():
	$Flowey / Flowey_Body.show()
	$Flowey / Flowey_Head.show()
	$Flowey / Animations.hide()


