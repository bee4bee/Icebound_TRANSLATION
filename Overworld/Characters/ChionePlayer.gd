extends KinematicBody2D


var speed = Vector2(0.0, 0.0)
export var speedgen = 4.5

var speedMulti = 1.0

onready var sprite = $AnimatedSprite
onready var sprDashtrail = $AnimatedSprite / Trail

export var canMove = true
var collider

export var hp = 20.0
export var immutime = 5.0

export var stamina = 50.0
export var canRegenStamina = false

onready var react = $Reaction
onready var maincam = get_parent().get_parent().find_node("Camera")


export var isInBattleMode = false
export var isInteracting = false

var tween = Tween.new()

func _ready():
	react.modulate.a = 0.0
	add_child(tween)
	_stamina_add()

var deltavar = 0.0

onready var archonfollower = get_parent().find_node("ArchonFollower")

func _process(delta):
	if archonfollower: $arrow.look_at(archonfollower.global_position)
	if $PlayerStats.isActive: canMove = false
	if $PlayerStats.isActive and Input.is_action_just_pressed("ui_cancel"): canMove = true
	
	
	
	$arrow.rotation -= PI / 2
	
	PlayerData.GlobalPosition = global_position
	PlayerData.playerSpeed = speed
	deltavar = delta
	if isInBattleMode: _damage_apply()
	
	$CanvasLayer / HUD._update_owPlayer_hp(hp)
	
	if canMove: _movement()
	

var isRunning = false
var canSprint = false
var canAttack = false

var isImmune = false
var sprintBoost = 1.0

var isStalling = false

var lastdir = " "

func _movement():
	
	collider = move_and_collide(Vector2(0, 0))
	
	if not isStalling:
		speed = Vector2(0.0, 0.0)
		speed.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))) * speedgen
		speed.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) * speedgen
		speed = speed.normalized() * speedMulti * sprintBoost * speedgen
	
	if sprintBoost < 1.0: sprintBoost = 1.0
	
	if Input.is_action_just_pressed("ui_right"): lastdir = "right"
	if Input.is_action_just_pressed("ui_left"): lastdir = "left"
	
	if Input.is_action_just_pressed("dash"): if canSprint and stamina >= 12.0 and speed != Vector2.ZERO and not isStalling: _sprintmovement()
	if Input.is_action_pressed("sprint") and stamina > 0.0:
		
		if speedMulti < 2: speedMulti += 0.03
	else: if speedMulti > 1: speedMulti -= 0.12
	
	if Input.is_action_just_pressed("PlayerOWAttack") and stamina >= 8.0 and not isStalling and canAttack:
		_attackAction()
	
	if speedMulti < 1: speedMulti = 1
	
	if speed == Vector2(0, 0): speedMulti = 1
	
	if not isStalling:
		if speed.x > 0 and speed.y == 0:
			if speed.x < 5.6: sprite.animation = "right"
			else: sprite.animation = "runRight"
		if speed.x < 0 and speed.y == 0:
			if speed.x > - 5.6: sprite.animation = "left"
			else: sprite.animation = "runLeft"
		if speed.y > 0:
			if speed.y < 5.6: sprite.animation = "down"
			else: sprite.animation = "runDown"
		if speed.y < 0:
			if speed.y > - 5.6: sprite.animation = "up"
			else: sprite.animation = "runUp"
	
	if speed.x > 5.6 or speed.x < - 5.6 or speed.y > 5.6 or speed.y < - 5.6: isRunning = true
	else: isRunning = false
	
	if not isStalling:
		if speed.x != 0 or speed.y != 0:
			if sprite.playing != true:
				sprite.frame = 0
			sprite.playing = true
		else:
			match sprite.animation:
				"runRight": sprite.animation = "right"
				"runLeft": sprite.animation = "left"
				"runUp": sprite.animation = "up"
				"runDown", "down": sprite.animation = "idle"
		
			if sprite.animation != "idle" and sprite.animation != "sit":
				sprite.playing = false
				sprite.frame = 1
			
		if Input.is_action_just_pressed("chionePlayerSit"):
			tween.interpolate_property(sprite, "scale:y", 1.5, 2, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
			sprite.animation = "sit"
			sprite.frame = 0
			sprite.playing = false
	
	if canMove == false:
		sprite.frame = 1
		sprite.playing = false
		
	move_and_slide(speed * 30, Vector2(0, 0), false, 2, 0.36, true)
	

var sprintval = 0.0

func _sprintmovement():
	canSprint = false
	sprintBoost = 4.0
	if isRunning: sprintBoost = 3.0
	sprintval = sprintBoost
	isImmune = true
	isStalling = true
	stamina -= 12.0
	
	
	tween.interpolate_property($AnimatedSprite.material, "shader_param/whitening", 1.0, 0.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "scale:y", 2.5, 1.9, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	$SlideTimingValues.position = speed * sprintBoost
	if $SlideTimingValues.position.x >= 0.0:
		sprite.animation = "SlideRight"
		sprDashtrail.scale.x = 1
	else:
		sprite.animation = "SlideLeft"
		sprDashtrail.scale.x = - 1
	
	sprDashtrail.emitting = true
	sprite.playing = true
	$Slide.play()
	
	tween.interpolate_property($SlideTimingValues, "position", $SlideTimingValues.position, Vector2(0, 0), 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	for i in 30:
		speed = $SlideTimingValues.position
		yield(get_tree().create_timer(0.005, false), "timeout")
	
	isImmune = false
	sprite.playing = false
	
	yield(get_tree().create_timer(0.2, false), "timeout")

	var x = sprite.animation
	sprite.animation = "SlideRecover"
	if x == "SlideRight": sprite.frame = 1
	if x == "SlideLeft": sprite.frame = 0
	$TransState.play()
	PlayerData._shakeobj(self)
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	sprintBoost = 1
	isStalling = false
	if sprite.frame == 1: sprite.animation = "right"
	else: sprite.animation = "left"
	
	yield(get_tree().create_timer(1, false), "timeout")
	canSprint = true


func _attackAction():
	isStalling = true
	canAttack = false
	sprite.playing = false
	sprite.frame = 0
	
	if lastdir == "right":
		sprite.animation = "AttackRight"
		$HitArea.scale.x = 1
	else:
		sprite.animation = "AttackLeft"
		$HitArea.scale.x = - 1
	
	$SlideTimingValues.position = speed
	speed = Vector2.ZERO
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	$Attack.play()
	sprite.playing = true
	$HitArea.monitorable = true
	$HitArea.monitoring = true
	
	tween.interpolate_property($SlideTimingValues, "position", $SlideTimingValues.position, Vector2(0, 0), 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	for i in 40:
		speed = $SlideTimingValues.position
		yield(get_tree().create_timer(0.003, false), "timeout")
	
	
	
	$HitArea.monitorable = false
	$HitArea.monitoring = false
	
	yield(get_tree().create_timer(0.2, false), "timeout")
	PlayerData._shakeobj(self)
	isStalling = false
	canAttack = true
	sprite.animation = lastdir
	sprite.frame = 1



func _stamina_add():
	while true:
		if canRegenStamina and stamina < 50.0: stamina += 0.9
		if speed.x > 5.0 or speed.x < - 5.0 or speed.y > 5.0 or speed.y < - 5.0:
			canRegenStamina = false
			stamina -= 0.7
		else: canRegenStamina = true
		
		
		if stamina > 50.0: stamina = 50.0
		if not isInBattleMode: stamina = 50.0
		
		$CanvasLayer / HUD._change_stamina(stamina)
		yield(get_tree().create_timer(0.2, false), "timeout")

func _react(frame):
	$reactSnd.play()
	react.position = Vector2(30, - 22)
	react.rotation = 0
	react.frame = frame
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(react, "rotation_degrees", react.rotation_degrees, 10, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(react, "modulate:a", 0.0, 1.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(react, "position", react.position, react.position + Vector2(10, - 6), 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	tween.interpolate_property(react, "modulate:a", 1.0, 0.0, 0.4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

signal enterBattleMode

func _battle_mode():
	isInBattleMode = true
	tween.interpolate_property($Soul, "modulate:a", $Soul.modulate.a, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	tween.interpolate_property($CanvasLayer / HUD, "rect_position:y", 80, - 15, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	emit_signal("enterBattleMode")
	tween.start()

var is_in_bullet = false
var is_moving = false
var can_hurt = false
var wait_time = 0.0

func _on_DamageArea_area_entered(area):
	
	if area.is_in_group("OWBullets") and not isImmune:
		print(1)
		if $DamageArea.get_overlapping_areas().size() == 0:
			is_in_bullet = false
		if $DamageArea.overlaps_body(area):
			is_in_bullet = true
		else: is_in_bullet = false
		if area.modulate == Color(0, 0.858, 0.98):
			if is_moving == false:
				is_in_bullet = false
			else: is_in_bullet = true
		if area.modulate == Color(1, 0.505, 0.019):
			if is_moving == true:
				is_in_bullet = false
			else: is_in_bullet = true;
		if area.modulate != Color(0, 0.858, 0.98) and area.modulate != Color(1, 0.505, 0.019):
			is_in_bullet = true

func _on_DamageArea_area_exited(area):
	is_in_bullet = false

func _damage_apply():
	if is_in_bullet:
		if can_hurt == true:
			wait_time = 0.0
			hp -= 3
			$Hurt.play()
			maincam.add_trauma(0.5)
			
			
			
			
			can_hurt = false
	
	if can_hurt == false:
		wait_time += 0.12 * deltavar * 40
	
	if wait_time < immutime:
		if int(wait_time) * 10 % 2 == 0 and int(wait_time) * 10 % 4 != 0:
			$Soul.modulate.a = 0.4
			$Soul / Light2D.energy = 0.3
		if int(wait_time) * 10 % 2 == 0 and int(wait_time) * 10 % 4 == 0:
			$Soul.modulate.a = 1.0
			$Soul / Light2D.energy = 0.8
	
	if wait_time >= immutime:
		
		can_hurt = true
		

func _play_hitminor():
	$Soulhit.play()

func _play_hitmajor():
	$Hurt.play()

func _play_fall():
	$Fall.play()


