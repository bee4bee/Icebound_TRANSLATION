extends Node2D


onready var cape = $Cape
onready var legs = $Legs
onready var torso = $Body / Torso
onready var arm = $Body / Arm
onready var hand = $Body / Arm / Hand
onready var head = $Body / Head
onready var axe = $Body / Axe

onready var body = $Body

var animvar = 0.6


func _ready():
	pass

func _process(delta):
	animvar += 0.07 * delta * 40
	
	
	body.position += Vector2(cos(animvar + 2) * 3 / 20, cos(animvar * 2.03) * 2 / 25)
	cape.position += Vector2(cos(animvar + 2) * 3 / 20, cos(animvar * 2.03) * 2 / 25)
	body.rotation_degrees += cos(animvar + 2) * 4 / 13 * delta * 40
	head.rotation_degrees += cos(animvar + 2) * 4 / 13 * delta * 40
	
	
	axe.rotation_degrees += cos(animvar + 4) * 5 / 11 * delta * 40
	
	arm.rotation_degrees += cos(animvar) * 5 / 13 * delta * 40
	hand.rotation_degrees += cos(animvar) * 4 / 12 * delta * 40
	legs.material.set("shader_param/offset_0_0", - Vector2(cos(animvar + 0.3) * 7 / 2, cos(animvar * 2.03) * 7 / 9))
	legs.material.set("shader_param/offset_1_0", - Vector2(cos(animvar + 0.3) * 7 / 2, cos(animvar * 2.03) * 7 / 9))
	

func _change_head_spr(frame):
	$Body / Head.frame = frame
