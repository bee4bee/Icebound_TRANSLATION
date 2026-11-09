extends Node2D


func _ready():
	pass

func _cast_dog(start, end, size, duration):
	scale = size
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "position", start, end, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
