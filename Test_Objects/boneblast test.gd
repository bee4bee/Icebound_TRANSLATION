extends Node2D

var boneblast = preload("res://Bullets/BoneBlast/BoneBlast.tscn")


func _ready():
	pass



func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var bullet = boneblast.instance()
		add_child(bullet)
		bullet._cast_boneblast(get_global_mouse_position(), 6.0)
