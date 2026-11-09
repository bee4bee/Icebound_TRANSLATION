extends KinematicBody2D

const gravity = 10

export var speed = 127
var motion = Vector2()
var act_count = 0
var can_move = true
var timecount = 0
var on_floor = false
var keycount = 0
var redsoul_sprite = preload("res://sprites/soul/spr_heartred_center_0.png")
var bluesoul_sprite = preload("res://sprites/soul/spr_heartblue_0.png")

var velograv = Vector2.ZERO
var gravcount = 0.0
var decrease = 0.0
func _ready():
	SignalSoul.connect("change_soul", self, "_soul_mode")

func _physics_process(delta):
	timecount += 1
	
	
	var velocity = Vector2()
	
	move_and_slide(velocity, Vector2(0, 0), false, 2, 0.36, true)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
	
	if keycount % 2 == 1:
		$Sprite.texture = redsoul_sprite
		$Trail.texture = redsoul_sprite
		
		
			
			
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if (speed > 0):
			if velocity.length() > 0:
				$Trail.emitting = true
				velocity = velocity * speed
			else:
				$Trail.emitting = false
		position += velocity * delta
	
	if keycount % 2 == 0:
		
		$Sprite.texture = bluesoul_sprite
		$Trail.texture = bluesoul_sprite
		
		
			
			
		velograv.x = 0
		if Input.is_action_pressed("ui_right"):
			velograv.x = 127
		if Input.is_action_pressed("ui_left"):
			velograv.x = - 127
		if Input.is_action_just_pressed("ui_up") and on_floor == true:
			velograv.y += - 12
		if Input.is_action_pressed("ui_up"):
			velograv.y += - 31
			gravcount += 1
			velograv.y += gravcount
			if gravcount > 31:
				gravcount = 31
		
		
		velograv.y += gravity
		velograv = move_and_slide_with_snap(velograv, Vector2.DOWN, Vector2.UP)
		

		if is_on_floor():
			on_floor = true
			gravcount = 0
		else: on_floor = false
		
	if timecount % 250 == 0:
		keycount += 1
	

