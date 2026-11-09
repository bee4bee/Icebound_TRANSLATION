extends Area2D


export var side = 0

var dir = ""
var speed = 0.0
var limit = 0.0

export var specrotation = 0.0

func _ready():
	$CollisionShape2D.shape = CapsuleShape2D.new()
	$CollisionShape2D.shape.radius = $Sprite.scale.y * 2
	$CollisionShape2D.shape.height = $Sprite.scale.x * 4
	
func _process(delta):
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
	rotation_degrees += 18.0 * delta * 40

func _cast_bullet(pos_start_x, pos_start_y, movement, direction, margin):
	$CollisionShape2D.shape = CapsuleShape2D.new()
	$CollisionShape2D.shape.radius = $Sprite.scale.y * 2
	$CollisionShape2D.shape.height = $Sprite.scale.x * 4
	
	position = Vector2(pos_start_x, pos_start_y)
	
	speed = movement
	dir = direction
	limit = margin

func _blue():
	modulate = Color(0, 0.27, 1)

func _orange():
	modulate = Color(1, 0.505, 0.019)
