extends NinePatchRect








func _ready():
	pass



func _process(delta):
	
	$Arena2.rect_size = rect_size
	$Arena2.rect_scale = rect_scale
	
	$ColorRect.rect_size = rect_size
	$ColorRect.rect_scale = rect_scale
