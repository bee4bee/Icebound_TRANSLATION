extends RayCast2D

func _ready():
	pass

func _cast_beam():
	$Tween.interpolate_property(self, "scale:x", 0.0, 10.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	show()
	$Tween.start()

func _recast():
	$Tween.interpolate_property(self, "scale:x", 10.0, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
