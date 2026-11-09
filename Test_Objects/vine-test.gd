extends Node2D



var vine_load = preload("res://Bullets/Vine/Vine.tscn")

func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var vine = vine_load.instance()
		add_child(vine)
		
		vine._cast_vine(Vector2(rand_range(25, 600), 0), rand_range( - 60, 60), 45.0)
		
