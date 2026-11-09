extends Node2D



var timer = 0.0

func _ready():
	pass



func _process(delta):
	timer += 0.04 * delta * 40
	$TorsoNew.position.y += cos(timer / 3) / 33 * delta * 20
	$TorsoNew.scale.y -= cos(timer / 7) / 6050 * delta * 40
	$LegsNew.scale.y -= cos(timer / 3) / 6050 * delta * 40
	$TorsoNew / ArmFlower.rotation_degrees -= cos(timer / 3) / 33 * delta * 70
