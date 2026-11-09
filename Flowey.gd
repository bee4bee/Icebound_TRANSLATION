extends Node2D

onready var head = $Flowey_Head
onready var body = $Flowey_Body

export var multiplier_head = 1.5

var head_rot = 0.0
var head_mov = 0.0

func _ready():
	_flowey_ready()

func _flowey_ready():
	
	
	pass

func _physics_process(delta):
	head_rot += delta * multiplier_head
	head_mov += delta * multiplier_head
	
	head.rotation += sin(head_rot) * 1.6 / 920
	head.position.x = head.position.x + cos(head_mov) * 3 / 78
	head.position.y = head.position.y + cos(head_mov) * 3 / 78
	body.material.set("shader_param/offset_1_0", - Vector2(cos(head_mov - 1) * 4 / 2, cos(head_mov - 1) * 4 / 7))

func _flowey_anim_show():
	$Flowey_Body.hide()
	$Flowey_Head.hide()
	$Animations.show()

func _flowey_anim_hide():
	$Flowey_Body.show()
	$Flowey_Head.show()
	$Animations.hide()

func _sink():
	$Animations.play("sink")

func _rise():
	$Animations.play("rise")
