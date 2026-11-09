extends Node2D
var angle = 0.0

var anim_var_arms = 0.0
var anim_var_torso = 0.0
var duration = 3.0

export var multiplier_arms = 0.3
export var multiplier_torso = 1.2

onready var tw = $Tween

var pos = []

func _ready():
	Sans_readypos()
	_reposition()

func Sans_readypos():
	pos.clear()
	for i in 8:
		pos.append(get_child(i).position)

func _reposition():
	for i in 8:
		get_child(i).position = pos[i]

func _physics_process(delta):
	
	anim_var_arms += delta * multiplier_arms
	$Sans_HandRight.rotation = cos(anim_var_arms * 4) / 12.8
	
	
	
	$Sans_HandLeft.rotation = - cos(anim_var_arms * 4) / 12.8
	
	
	
	anim_var_torso += delta * multiplier_torso
	$Sans_Torso.position.y += cos(anim_var_torso) * 5 / 90
	$Sans_Torso.rotation -= cos(anim_var_torso) / 800
	$scarf.rotation -= cos(anim_var_torso) / 800
	
	$Sans_Legs.scale.y = $Sans_Legs.scale.y - cos(anim_var_torso) * 2.7 / 930
	
	
	$Sans_Head.position.y += cos(anim_var_torso) / 14
	$flower.position.y += cos(anim_var_torso) / 14
	$Sans_Head.rotation -= cos(anim_var_torso) / 950
	$flower.rotation -= cos(anim_var_torso) / 950
	
	
	

func _slamUp():
	
	set_physics_process(false)
	move_child($Sans_HandRight, 6)
	$Sans_HandRight.frame = 0
	$Sans_HandRight.play("slamup")
	yield(get_tree().create_timer(0.05, false), "timeout")
	for i in 8:
		if i != 2 and i != 5 and i != 7: tw.interpolate_property(get_child(i), "position:y", get_child(i).position.y, get_child(i).position.y - 5, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		if i == 5 or i == 7: tw.interpolate_property(get_child(i), "position:y", get_child(i).position.y, get_child(i).position.y - 6, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(0.55, false), "timeout")
	$Sans_HandRight.frame = 0
	$Sans_HandRight.play("slamdown")
	
	for i in 8:
		if i != 2 and i != 5 and i != 7: get_child(i).position.y += 5
		if i == 5 or i == 7: get_child(i).position.y += 6
	
	move_child($Sans_HandRight, 4)
	yield(get_tree().create_timer(0.35, false), "timeout")
	$Sans_HandRight.frame = 0
	$Sans_HandRight.animation = "default"
	$Sans_HandRight.playing = false
	set_physics_process(true)

func _slamDown():
	
	set_physics_process(false)
	move_child($Sans_HandRight, 6)
	$Sans_HandRight.frame = 0
	$Sans_HandRight.play("slamdown")
	yield(get_tree().create_timer(0.05, false), "timeout")
	for i in 8:
		if i != 2 and i != 5 and i != 7: tw.interpolate_property(get_child(i), "position:y", get_child(i).position.y, get_child(i).position.y + 6, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		if i == 5 or i == 7: tw.interpolate_property(get_child(i), "position:y", get_child(i).position.y, get_child(i).position.y + 7, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(0.55, false), "timeout")
	$Sans_HandRight.frame = 0
	$Sans_HandRight.animation = "default"
	$Sans_HandRight.playing = false
	
	for i in 8:
		if i != 2 and i != 5 and i != 7: get_child(i).position.y -= 6
		if i == 5 or i == 7: get_child(i).position.y -= 7
	tw.start()
	move_child($Sans_HandRight, 4)
	yield(get_tree().create_timer(0.35, false), "timeout")
	set_physics_process(true)

func _slamLeft():
	
	set_physics_process(false)
	move_child($Sans_HandRight, 7)
	$Sans_HandRight.frame = 0
	$Sans_HandRight.play("slamleft")
	yield(get_tree().create_timer(0.05, false), "timeout")
	for i in 8:
		if i != 2: tw.interpolate_property(get_child(i), "position:x", get_child(i).position.x, get_child(i).position.x - 4, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		if i == 5 or i == 7: tw.interpolate_property(get_child(i), "position:x", get_child(i).position.x, get_child(i).position.x - 5, 0.55, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(0.55, false), "timeout")
	$Sans_HandRight.frame = 0
	$Sans_HandRight.play("leftrecov")
	
	for i in 8:
		if i != 2 and i != 5 and i != 7: get_child(i).position.x += 4
		if i == 5 or i == 7: get_child(i).position.x += 5
	
	yield(get_tree().create_timer(0.15, false), "timeout")
	move_child($Sans_HandRight, 4)
	yield(get_tree().create_timer(0.2, false), "timeout")
	set_physics_process(true)
	$Sans_HandRight.frame = 0
	$Sans_HandRight.animation = "default"
	$Sans_HandRight.playing = false

func _resizesquish():
	tw.interpolate_property(self, "scale:x", 1.3, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.interpolate_property(self, "scale:y", 0.8, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()

func _shrugdodge():
	$Sans_HandLeft.frame = 1
	$Sans_HandRight.frame = 1
	$Sans_Head.frame = 1
	yield(get_tree().create_timer(0.8, false), "timeout")
	$Sans_HandLeft.frame = 0
	$Sans_HandRight.frame = 0
	$Sans_Head.frame = 0
