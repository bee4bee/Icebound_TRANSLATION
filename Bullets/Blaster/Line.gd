extends NinePatchRect

var timer = 0.0

func _ready():
	pass

func _process(delta):
	timer += 1.0
	rect_size.x += cos(timer / 1.5) * 6 * delta

func _cast_beam():
	$Tween.interpolate_property(self, "rect_scale:x", 0.0, 1.2, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property($Light2D, "scale:y", 0.0, 0.7, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	show()

func _recast():
	$Tween.interpolate_property(self, "rect_scale:x", 1.2, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property($Light2D, "scale:y", 0.7, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
