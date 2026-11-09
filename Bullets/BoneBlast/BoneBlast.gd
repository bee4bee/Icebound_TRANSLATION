extends Node2D


var bone = preload("res://Bullets/Bone/Bone.tscn")

onready var exclamation = $Exclamation
onready var blast = $Blast

onready var bones = $Bones

onready var tween = $Tween

var directionArrayX = []
var directionArrayY = []
var rotationArray = []

var bulletAmount = 0.0
var timer = 0.0


func _ready():
	tween.interpolate_property(exclamation, "scale", Vector2(0.0, 0.0), Vector2(1, 1), 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	$Warning.play()

var canCast = true

func _process(delta):
	timer += 1 * delta * 40
	
	if timer >= 30 and canCast:
		canCast = false
		exclamation.hide()
		blast.show()
		
		tween.interpolate_property(blast, "scale", Vector2(1, 1), Vector2(6, 6), 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(blast, "modulate:a", 1, 0, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		_spawn_bones()
		$Boom.play()
	
	if timer > 30:
		for index in bones.get_children():
			index.position += Vector2(directionArrayX[index.get_index()] * delta * 40, directionArrayY[index.get_index()] * delta * 40)
			index.rotation_degrees += rotationArray[index.get_index()] * delta * 40
			
			directionArrayX[index.get_index()] -= directionArrayX[index.get_index()] / 20 * delta * 40
			directionArrayY[index.get_index()] += 0.3 * delta * 40
			rotationArray[index.get_index()] -= rotationArray[index.get_index()] / 19 * delta * 40


func _cast_boneblast(pos, amount):
	position = pos
	bulletAmount = amount
	
	directionArrayX.resize(amount)
	directionArrayY.resize(amount)
	rotationArray.resize(amount)
	
	for index in amount:
		directionArrayX[index] = rand_range( - 9, 9)
		directionArrayY[index] = rand_range( - 1, - 7)
		rotationArray[index] = rand_range( - 6, 6)


func _spawn_bones():
	for index in bulletAmount:
		var bullet = bone.instance()
		bones.add_child(bullet)
		
		var dimension = rand_range(15, 35)
		bullet._cast_bullet(Vector2(0, 0), Vector2(0, 0), Vector2(10, dimension), 0.5, 0.0, "left", - 600)
