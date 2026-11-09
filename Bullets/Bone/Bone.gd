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
	$CollisionShape2D.position = $BoneSprite.rect_position + ($BoneSprite.rect_size / 2.0)
	$CollisionShape2D.shape.extents = Vector2(($BoneSprite.rect_size.x / 2.0) - 2, ($BoneSprite.rect_size.y / 2.0) - 5)
	
	$CollisionShape2D.rotation_degrees = $BoneSprite.rect_rotation
	
	$BoneSprite.rect_pivot_offset = Vector2($BoneSprite.rect_size.x / 2, $BoneSprite.rect_size.y / 2)
	match dir:
		"left":
			position.x -= speed * delta * 40
			if position.x < limit: queue_free()
		"right":
			position.x += speed * delta * 40
			if position.x > limit: queue_free()
		"up":
			position.y -= speed * delta * 40
			if position.y < limit: queue_free()
		"down":
			position.y += speed * delta * 40
			if position.y > limit: queue_free()
	
func _cast_bullet(posStart, pos, size, duration, movement, direction, margin):
	var tween = Tween.new()
	tween.interpolate_property($BoneSprite, "rect_size", Vector2(10, 10), size, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	position = posStart
	tween.interpolate_property($BoneSprite, "rect_position", $BoneSprite.rect_position, pos, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)
	tween.start()
	
	$CollisionShape2D.shape = RectangleShape2D.new()
	
	speed = movement
	dir = direction
	limit = margin

func _ease_in(pos, duration):
	var tween = Tween.new()
	add_child(tween)
	speed = 0
	tween.interpolate_property(self, "position", position, pos, duration, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()

func _cast_bullet_elastic(posStart, pos, size, duration, rot):
	rotation_degrees = rot
	position = posStart
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($BoneSprite, "rect_size", Vector2(10, 10), size, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($BoneSprite, "rect_position", $BoneSprite.rect_position, pos, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func _rotate_bone(rotInitial, rotFinal, duration):
	var tween = Tween.new()
	tween.interpolate_property(self, "rotation_degrees", rotInitial, rotFinal, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)
	tween.start()

func _resize_bone(size, duration):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($BoneSprite, "rect_size", $BoneSprite.rect_size, size, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _blue():
	modulate = Color(0, 0.27, 1)

func _orange():
	modulate = Color(1, 0.505, 0.019)
