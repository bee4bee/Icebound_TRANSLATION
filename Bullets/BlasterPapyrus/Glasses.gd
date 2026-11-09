extends Sprite

var speed_fall_x = int(rand_range( - 8.0, 8.0))
var speed_fall_y = - 10.0
var rotationval = int(rand_range( - 15.0, 15.0))

func _ready():
	pass

func _process(delta):
	position.y += speed_fall_y * delta * 15
	position.x += speed_fall_x * delta * 40
	rotation_degrees += rotationval * delta * 12
	
	if speed_fall_x > 0: speed_fall_x -= 0.15
	if speed_fall_x < 0: speed_fall_x += 0.15
	if rotationval > 0: rotationval -= 1.0
	if rotationval > 0: rotationval += 1.0
	speed_fall_y += 0.6
