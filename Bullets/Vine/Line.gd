extends Line2D






var timer = 0.0


func _ready():
	pass



func _process(delta):
	timer += 1.0 * delta * 40
	scale.x += cos(timer / 1.5) * 6 * delta

func _cast_beam():
	$Tween.interpolate_property(
		self, 
		"scale:y", 
		0.0, 
		1.4, 
		0.3, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self, 
		"modulate:a", 
		0.0, 
		1.0, 
		0.3, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	$Tween.start()
	show()

func _recast():
	$Tween.interpolate_property(
		self, 
		"scale:y", 
		1.4, 
		0.0, 
		0.3, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self, 
		"modulate:a", 
		1.0, 
		0.0, 
		0.3, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	$Tween.start()
