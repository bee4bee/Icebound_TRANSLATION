extends KinematicBody2D

export var speed = 400
var screen_size
var motion = Vector2()
var act_count = 0
var can_move = true

func _ready():
	screen_size = get_viewport_rect().size
	SignalTest.connect("collide_act", self, "_speed_change")

func _physics_process(delta):
	
	
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if (speed > 0):
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite.animation = "up"
		if Input.is_action_pressed("ui_down"):
			$AnimatedSprite.animation = "down"
		
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed(("ui_down")):
			$AnimatedSprite.animation = "left"
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed(("ui_down")):
			$AnimatedSprite.animation = "right"
		
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite.animation = "up"
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite.animation = "up"
		if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite.animation = "down"
		if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite.animation = "down"
		
		if velocity.length() > 0:
			velocity = velocity * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.frame = 0
			$AnimatedSprite.stop()
			
	else:
		$AnimatedSprite.frame = 0
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	move_and_slide(motion, Vector2(0, 0), false, 2, 0.36, true)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
	

func _speed_change(speedvar):
	speed = speedvar
	print(speed, " ", speedvar)
