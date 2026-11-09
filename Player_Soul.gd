extends KinematicBody2D

export var speed = 135
export var can_move = true

export var hp = 20

var motion = Vector2.ZERO
var act_count = 0
var timecount = 0
var on_floor = false
var keycount = 0

var current_soul_sprite

var redsoul_sprite = "res://sprites/soul/btredsoul.png"
var orangesoul_sprite = "res://sprites/soul/soulorange.png"
var bluesoul_sprite = "res://sprites/soul/spr_heartblue_0.png"
var bluesoul_sprite_upsidedown = "res://sprites/soul/spr_heartblue_1.png"
var bluesoul_sprite_right = "res://sprites/soul/spr_heartblue_2.png"
var bluesoul_sprite_left = "res://sprites/soul/spr_heartblue_3.png"
var cyanSoul_sprite = "res://sprites/soul/soulCyan.png"

onready var camera = get_node("/root/Battle_Engine/Camera")

var gravity = 5

var jump = Vector2(40, 260)

var inputList: = [0, 0, 0, 0]
var input: = Vector2()

var can_jump = false

export var is_in_bullet = false
var color_damage = false
var can_hurt = true
var wait_time = 0.0
export var immunity_time = 0.4
export var damage = 1

export var velocity = Vector2.ZERO

var deltavar = 0.0

export var is_moving = false

export var soul_is_active = false

signal current_hp(hp_amount)

func _ready():
	current_soul_sprite = redsoul_sprite
	
func _process(delta):
	
	if hp <= 0:
		hp = 0
		get_tree().change_scene("res://GameOverScreen/EndScreen.tscn")
	if hp > 20: hp = 20
	for i in $Area2D.get_overlapping_areas(): _on_Area2D_area_entered(i)
	
	SoulPositionSingleton.soulPosition = position
	_check_impact()
	
	
	
	emit_signal("current_hp", hp)
	_damage_apply()
	
	if soul_is_active == false:
		can_move = false
		hide()
	else:
		can_move = true
		show()
	

func _blink():
	$Trail2.restart()
	$Trail2.emitting = true

func _blinksound():
	$ChangeMode.play()


var cyanOverride = false
signal CyanTimer(period)

func _fixtexture():
	$Sprite.texture = current_soul_sprite
	$Trail.texture = current_soul_sprite
	$Trail2.texture = current_soul_sprite
	$Trail.emitting = true

func _red():
	velocity = Vector2.ZERO
	var soul_vel = 3.2
	$Damage_Particle.modulate = Color(1, 0, 0)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= 1.5
	
	rotation_degrees = 0
	current_soul_sprite = load(redsoul_sprite)
	if cyanOverride:
		current_soul_sprite = load(cyanSoul_sprite)
	
	_fixtexture()
	
	if Input.is_action_pressed("ui_up"):
		is_moving = true
		velocity.y -= soul_vel
	if Input.is_action_pressed("ui_down"):
		is_moving = true
		velocity.y += soul_vel
	if Input.is_action_pressed("ui_right"):
		is_moving = true
		velocity.x += soul_vel
	if Input.is_action_pressed("ui_left"):
		is_moving = true
		velocity.x -= soul_vel
		
	if velocity == Vector2(0, 0):
		is_moving = false
	
	if speed:
		if velocity.length() > 0:
			$Trail.emitting = true
			velocity = velocity
		else:
			$Trail.emitting = false
		move_and_slide(velocity * 40, Vector2(0, 0), true)

func _cyan(timer):
	var posstart = position
	$Shade.emitting = true
	cyanOverride = true
	
	$tick.playing = true
	
	for i in int(timer):
		$Label.text = str(timer - i)
		yield(get_tree().create_timer(1, false), "timeout")
	
	$Label.text = " "
	var tw = Tween.new()
	add_child(tw)
	tw.interpolate_property(self, "position", position, posstart, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
	
	PlayerData._tempSlowdown(0.08)
	$tick.playing = false
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	
	cyanOverride = false
	tw.queue_free()

export var slam_multiplier = 1.0

func _orange():
	current_soul_sprite = load(orangesoul_sprite)
	_fixtexture()
	
	velocity = Vector2.ZERO
	var soul_vel = 3.2
	$Damage_Particle.modulate = Color(1, 0.5, 0)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= 1.5
	
	rotation_degrees = 0
	if Input.is_action_pressed("ui_up"):
		is_moving = false
		velocity.y -= soul_vel
	if Input.is_action_pressed("ui_down"):
		is_moving = false
		velocity.y += soul_vel
	if Input.is_action_pressed("ui_right"):
		is_moving = false
		velocity.x += soul_vel
	if Input.is_action_pressed("ui_left"):
		is_moving = false
		velocity.x -= soul_vel
		
	if velocity == Vector2(0, 0):
		is_moving = true
	
	if speed:
		if velocity.length() > 0:
			$Trail.emitting = true
			velocity = velocity
		else:
			$Trail.emitting = false
		move_and_slide(velocity * 40, Vector2(0, 0), true)

func _blue_down():
	var soul_vel = speed
	$Damage_Particle.modulate = Color(0, 0, 1)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= speed / 2
	
	rotation_degrees = 0
	current_soul_sprite = load(bluesoul_sprite)
	_fixtexture()
	
	gravity = 420 * slam_multiplier
	
	inputList = [
		int(Input.is_action_pressed("ui_right")), 
		int(Input.is_action_pressed("ui_left")), 
		int(Input.is_action_pressed("ui_up")), 
		]
	if not is_on_floor():
		motion.y += gravity * get_process_delta_time()
	input.x = inputList[0] - inputList[1]
	input.y = inputList[2]
	motion.x = soul_vel * input.x
	
	if is_on_floor():
		motion.y = 0
		if inputList[2]:
			motion.y = - jump.y
	else:
		if not inputList[2] and motion.y < - jump.x:
			motion.y = - jump.x

	if is_on_ceiling() and motion.y < - jump.x:
		motion.y = - jump.x / 2.0
	if motion.x != 0 or Input.is_action_pressed("ui_up"):
		is_moving = true
	
	else: is_moving = false
	move_and_slide(motion, Vector2.UP)

func _blue_up():
	var soul_vel = speed
	$Damage_Particle.modulate = Color(0, 0, 1)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= speed / 2
	
	current_soul_sprite = load(bluesoul_sprite_upsidedown)
	_fixtexture()
	
	gravity = - 420 * slam_multiplier
	
	inputList = [
		int(Input.is_action_pressed("ui_right")), 
		int(Input.is_action_pressed("ui_left")), 
		int(Input.is_action_pressed("ui_down")), 
		]
	
	if not is_on_floor():
		motion.y += gravity * get_process_delta_time()

	input.x = inputList[0] - inputList[1]
	input.y = inputList[2]
	motion.x = soul_vel * input.x
	if is_on_floor():
		motion.y = 0
		if inputList[2]:
			motion.y = jump.y
	else:
		if not inputList[2] and motion.y > jump.x:
			motion.y = jump.x
	
	if is_on_ceiling() and motion.y < jump.x:
		motion.y = - jump.x / 2.0
	
	if motion.x != 0 or Input.is_action_pressed("ui_up"):
		is_moving = true
	
	else: is_moving = false
	
	move_and_slide(motion, Vector2.DOWN)

func _blue_right():
	var soul_vel = speed
	$Damage_Particle.modulate = Color(0, 0, 1)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= speed / 2
	
	rotation_degrees = 0
	current_soul_sprite = load(bluesoul_sprite_right)
	_fixtexture()
	
	gravity = 420 * slam_multiplier
	
	inputList = [
		int(Input.is_action_pressed("ui_down")), 
		int(Input.is_action_pressed("ui_up")), 
		int(Input.is_action_pressed("ui_left")), 
		]
	if not is_on_floor():
		motion.x += gravity * get_process_delta_time()
	input.y = inputList[0] - inputList[1]
	input.x = inputList[2]
	motion.y = soul_vel * input.y
	
	if is_on_floor():
		motion.x = 0
		if inputList[2]:
			motion.x = - jump.y
	else:
		if not inputList[2] and motion.x < - jump.x:
			motion.x = - jump.x

	if is_on_ceiling() and motion.x < - jump.x:
		motion.x = - jump.x / 2.0
	
	if motion.y != 0 or Input.is_action_pressed("ui_left"):
		is_moving = true
	
	else: is_moving = false
	move_and_slide(motion, Vector2.LEFT)

func _blue_left():
	var soul_vel = speed
	$Damage_Particle.modulate = Color(0, 0, 1)
	
	if Input.is_action_pressed("x_hold"):
		soul_vel -= speed / 2
	
	current_soul_sprite = load(bluesoul_sprite_left)
	_fixtexture()
	
	gravity = - 420 * get_process_delta_time()
	
	inputList = [
		int(Input.is_action_pressed("ui_down")), 
		int(Input.is_action_pressed("ui_up")), 
		int(Input.is_action_pressed("ui_right")), 
		]
	
	if not is_on_floor():
		motion.x += gravity * get_process_delta_time()
	input.y = inputList[0] - inputList[1]
	input.x = inputList[2]
	motion.y = soul_vel * input.y
	
	if is_on_floor():
		motion.x = 0
		if inputList[2]:
			motion.x = jump.y
	else:
		if not inputList[2] and motion.x > jump.x:
			motion.x = jump.x
	
	if is_on_ceiling() and motion.x < jump.y:
		motion.x = - jump.y / 2.0
	
	if motion.y != 0 or Input.is_action_pressed("ui_up"):
		is_moving = true
	
	else: is_moving = false
	
	move_and_slide(motion, Vector2.RIGHT)

func _check_impact():
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		if slam_multiplier > 4.0:
			camera.add_trauma(0.5)
			$Impact.play()
		if slam_multiplier > 1.0: slam_multiplier = 1.0



func _on_Area2D_area_entered(area):
	if $Area2D.get_overlapping_areas().size() == 0: is_in_bullet = false
	if $Area2D.overlaps_body(area):
		is_in_bullet = true
	else: is_in_bullet = false
	if area.modulate == Color(0, 0.27, 1):
		if is_moving == false:
			is_in_bullet = false
		else: is_in_bullet = true
	if area.modulate == Color(1, 0.505, 0.019):
		if is_moving == true:
			is_in_bullet = false
		else: is_in_bullet = true;
	if area.modulate != Color(0, 0.27, 1) and area.modulate != Color(1, 0.505, 0.019):
		is_in_bullet = true

func _setDeltagrav(m1, m2):
	m1 *= get_process_delta_time() * 40 * 2

func _on_Area2D_area_exited(area):
	is_in_bullet = false
	
func _damage_apply():
	if is_in_bullet:
		if can_hurt == true:
			wait_time = 0.0
			hp -= damage
			if PlayerData.Name.to_lower() == "kekuus":
				hp -= damage
			
			$Damage_Particle.emitting = true
			$Hurt.play()
			can_hurt = false
	
	if can_hurt == false:
		wait_time += 0.1 * get_process_delta_time() * 40
	
	if wait_time < immunity_time:
		if int(wait_time) * 10 % 2 == 0 and int(wait_time) * 10 % 4 != 0:
			$Sprite.modulate.a = 0.4
		if int(wait_time) * 10 % 2 == 0 and int(wait_time) * 10 % 4 == 0:
			$Sprite.modulate.a = 1.0
	
	if wait_time >= immunity_time:
		$Sprite.modulate.a = 1.0
		can_hurt = true
		$Damage_Particle.emitting = false
	

func _debug_heal():
	if Input.is_key_pressed(KEY_E):
		pass
