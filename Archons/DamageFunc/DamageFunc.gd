extends Label

var tw = Tween.new()
func _ready():
	add_child(tw)
	_attackReact(15)

func _attackReact(amt):
	text = str(int(amt))
	show()
	
	tw.interpolate_property(self, "rect_position:y", rect_position.y, rect_position.y - 65, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.interpolate_property(self, "modulate:a", 0, 1, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(0.6, false), "timeout")
	tw.interpolate_property(self, "rect_position:y", rect_position.y, rect_position.y + 30, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN)
	yield(get_tree().create_timer(0.3, false), "timeout")
	for i in 4:
		if i % 2 == 1: hide()
		else: show()
		yield(get_tree().create_timer(0.07, false), "timeout")
