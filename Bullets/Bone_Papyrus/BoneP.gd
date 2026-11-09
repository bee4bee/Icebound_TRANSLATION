extends Area2D

onready var bullet = $BoneSprite
onready var collision = $CollisionShape2D
var index = 0

var speed = 0.0
var dir = ""
var limit = 0.0

func _ready():
	
	pass

func _process(delta):
	collision.position = $BoneSprite.rect_position + ($BoneSprite.rect_size / 2.0)
	collision.shape.extents = Vector2(($BoneSprite.rect_size.x / 2.0) - 4, ($BoneSprite.rect_size.y / 2.0) - 6)
	
	collision.rotation_degrees = $BoneSprite.rect_rotation
	
	match dir:
		"left", "up":
			position.x -= speed * delta * 40
			if position.x < limit: queue_free()
		"right", "down":
			position.x += speed * delta * 40
			if position.x > limit: queue_free()

func _cast_bullet(posStart, pos, size, duration, movement, direction, margin):
	var tween = Tween.new()
	tween.interpolate_property($BoneSprite, "rect_size", $BoneSprite.rect_size, size, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	position = posStart
	tween.interpolate_property($BoneSprite, "rect_position", $BoneSprite.rect_position, pos, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)
	tween.start()
	
	collision.shape = RectangleShape2D.new()
	
	speed = movement
	dir = direction
	limit = margin

func _change_size(size, duration):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($BoneSprite, "rect_size", $BoneSprite.rect_size, size, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _blue():
	modulate = Color(0, 0.27, 1)

func _orange():
	modulate = Color(1, 0.505, 0.019)
