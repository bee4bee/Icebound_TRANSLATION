extends Node2D

onready var arrow = $Sprite
var tween = Tween.new()

func _ready():
	add_child(tween)

func _cast_arrow(position, rotation):
	$AudioStreamPlayer.play()
	arrow.position = position
	arrow.rotation_degrees = rotation
	tween.interpolate_property(arrow, "scale", arrow.scale, Vector2(2.0, 2.0), 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(arrow, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(2.0, false), "timeout")
	self.queue_free()
