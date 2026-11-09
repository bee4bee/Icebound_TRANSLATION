extends Node2D

var tween = Tween.new()

func _ready():
	add_child(tween)


func _cast(pos, posfin, size, timein, time):
	position = pos
	$NinePatchRect.scale = Vector2(1.2, 1.2)
	tween.interpolate_property(self, "position", pos, posfin, timein, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(time, false), "timeout")
	tween.interpolate_property(self, "position", self.position, pos - Vector2(100, 0), 0.8, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()

func _castFull(pos, time, angle: float = - 90):
	var x = int(rand_range(0.1, 1.9))
	if x == 0: scale.y *= - 1
	
	rotation_degrees = angle
	position = pos
	$AudioStreamPlayer.play()
	$NinePatchRect.position.x -= 500
	tween.interpolate_property($NinePatchRect, "position:x", $NinePatchRect.position.x, $NinePatchRect.position.x + 500, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(time, false), "timeout")
	tween.interpolate_property($NinePatchRect, "position:x", $NinePatchRect.position.x, $NinePatchRect.position.x - 600, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(1.1, false), "timeout")
	queue_free()
