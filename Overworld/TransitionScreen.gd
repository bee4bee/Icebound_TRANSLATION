extends Node2D


export var index = 0.0
onready var soul = $Soul
onready var rect = $ColorRect

onready var bt_int = $btInitiate
onready var bt_start = $btStart
var tween = Tween.new()

export var scene_change = ""

func _ready():
	add_child(tween)


func _boot():
	for i in 5:
		if i % 2 == 0:
			modulate.a = 1
			bt_int.play()
		else: modulate.a = 0
		yield(get_tree().create_timer(0.05, false), "timeout")
	
	yield(get_tree().create_timer(0.12, false), "timeout")
	bt_start.play()
	tween.interpolate_property(soul, "position", soul.position, Vector2(320, 400), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(soul, "modulate:a", 1.0, 0.0, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(get_tree().create_timer(1.25, false), "timeout")
	get_tree().change_scene(scene_change)

func _fakeflash():
	for i in 4:
		if i % 2 == 0:
			modulate.a = 1
			bt_int.play()
		else: modulate.a = 0
		yield(get_tree().create_timer(0.1, false), "timeout")
