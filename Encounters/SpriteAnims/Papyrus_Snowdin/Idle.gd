extends Node2D


onready var idlecape = $Cape
onready var idlelegs = $Legs
onready var idletorso = $Torso
onready var idlearm = $Arm
onready var idlehead = $Head

var animvar = 0.6

export var addition = 0.09

var idleanimvar = 0.0

func _ready():
	pass

func _process(delta):
	idleanimvar += 0.04 * delta * 40
	
	
	idletorso.position.y += cos(idleanimvar) * 9 / 250
	$Sprite.position.y += cos(idleanimvar) * 9 / 250
	idlecape.position.y += cos(idleanimvar) * 9 / 250
	
	
	
	idlehead.position = idletorso.position + Vector2(2, - 30)
	
	
	idlearm.position = idletorso.position + Vector2(20, - 20)
	idlearm.rotation_degrees -= cos(idleanimvar + 2) * 1.3 / 14 * delta * 40
	idlehead.rotation_degrees -= cos(idleanimvar + 0.6) * 1.3 / 10 * delta * 40
	
	idlelegs.material.set("shader_param/offset_0_0", + Vector2(0, cos(idleanimvar + 1) * 10 / 5))


func _change_head_spr(frame):
	$Head.frame = frame
