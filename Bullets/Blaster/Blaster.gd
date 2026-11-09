extends Node2D


onready var maincam = get_node("/root/Battle_Engine/Camera")
onready var beam = $Beam

var timer = 0.0
var maxtime = 0.0

var beamcast = false
var moveblaster = false
var canrecast = true
var speed = 2.0


func _ready():
	$Sprite / BootUp.emitting = true
	if not PlayerData.addParticles: $Sprite / BootUp.hide()


func _process(delta):
	
	$Raycast.scale.y = 1000
	
	timer += 1 * delta * 40
	if timer >= maxtime and timer < maxtime + 15:
		$Sprite.play("ready")
	
	if timer >= maxtime + 13 and timer < maxtime + 15:
		$Sprite.play("beginfire")
	
	if timer >= maxtime + 15:
		$Sprite.playing = true
		$Sprite.play("fire")
		
		if beamcast == false:
			$Fire.play()
			beamcast = true
			$Beam.enabled = true
			$Line._cast_beam()
			$Beam._cast_beam()
			
			$Raycast.monitorable = true
			$Raycast.monitoring = true
			$Tween.interpolate_property($Raycast, "scale:x", 0, 1, 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
			$Tween.start()
			
			maincam.add_trauma(0.5)
	
	if timer >= maxtime + 22 and moveblaster == false:
		moveblaster = true
	
	if moveblaster == true:
		var angle = rotation - PI / 2.0
		var dir = Vector2(cos(angle), sin(angle))
		position += dir * (speed * delta)
		speed += speed / 1.8 * delta * 40
		if speed >= 2300.0: speed = 2300.0
		
	if timer >= maxtime + 28 and canrecast == true:
		canrecast = false
		$Beam.enabled = false
		
		$Line._recast()
		$Beam._recast()
		$Raycast.monitorable = false
		$Raycast.monitoring = false
		$Raycast.scale = Vector2.ZERO
		$Raycast / CollisionShape2D.queue_free()
	
	if timer >= maxtime + 100:
		get_parent().remove_child(self)
		set_process(false)

func _cast_blaster(pos_start_x, pos_start_y, pos_final_x, pos_final_y, pos_start_rot, pos_final_rot, scale_blaster, wait_time):
	
	scale.x = scale_blaster
	$Load.play()
	
	maxtime = wait_time
	position = Vector2(pos_start_x, pos_start_y)

	var tween = Tween.new()
	
	tween.interpolate_property(self, "position", position, Vector2(pos_final_x, pos_final_y), 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(self, "rotation_degrees", pos_start_rot, pos_final_rot, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)

	tween.start()

func _cast_blaster_without_rotation(pos_start, pos_end, scale_blaster, wait_time):
	scale.x = scale_blaster
	$Load.play()
	maxtime = wait_time
	position = pos_start

	var tween = Tween.new()
	tween.interpolate_property(self, "position", position, pos_end, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)
	tween.start()
