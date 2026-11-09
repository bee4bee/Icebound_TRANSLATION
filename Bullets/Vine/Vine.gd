extends Node2D

onready var area = $Area
onready var collision = $Area / CollisionShape2D
onready var sprite = $VineSprite

var isCasting = false
var index = 0.0
var tween = Tween.new()

var canEndCast = true
func _ready():
	add_child(tween)
	
	sprite.rect_size.y = 0.0

func _process(delta):
	collision.position = sprite.rect_position + (sprite.rect_size / 2.0)
	collision.shape.extents = Vector2((sprite.rect_size.x / 2.0) - 6, (sprite.rect_size.y / 2.0) - 1)
	collision.rotation_degrees = sprite.rect_rotation
	
	if isCasting == true:
		index -= 1.0 * delta * 40
		if index <= 0.0 and canEndCast == true:
			_endcast_vine()
			canEndCast = false
		
		if index <= - 35:
			get_parent().remove_child(self)
			self.set_process(false)

func _cast_vine(pos, rot, time):
	
	$AudioStreamPlayer.play()
	collision.shape = RectangleShape2D.new()
	
	rotation_degrees = rot
	position = pos
	tween.interpolate_property(sprite, "rect_size:y", 0, 520, 1.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()
	
	index = time
	isCasting = true
	yield(get_tree().create_timer(1.0, false), "timeout")
	$Line.hide()

func _endcast_vine():
	$Line.hide()
	tween.interpolate_property(sprite, "rect_size:y", 520, 0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
