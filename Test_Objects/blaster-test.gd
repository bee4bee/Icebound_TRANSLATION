extends Node2D






var blaster_load = preload("res://Bullets/Blaster/Blaster.tscn")
var glassload = preload("res://Bullets/BlasterPapyrus/Glasses.tscn")

func _ready():
	pass


func _process(delta):
	
	
	if Input.is_action_just_pressed("ui_accept"):
		var blaster = glassload.instance()
		add_child(blaster)
		blaster.position = get_global_mouse_position()
		
		
		
		
		if blaster.is_processing() == false:
			remove_child(blaster)
