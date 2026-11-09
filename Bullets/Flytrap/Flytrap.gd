extends Area2D

var fly = preload("res://Bullets/Flytrap/Fly.tscn")

onready var tween = $Tween

func _ready():
	pass

func _process(delta):
	for i in self.get_children():
		if i.get_index() > 2:
			if i.position == Vector2(0, 0):
				i.queue_free()
		


func _cast_fly(amount):
	yield(get_tree().create_timer(0.1, false), "timeout")
	$AnimatedSprite.playing = true
	for i in amount:
		var bullet = fly.instance()
		add_child(bullet)
		bullet.position = Vector2(10, 10)
		bullet.scale = Vector2(0.7 / scale.x, 0.7 / scale.y)
		bullet.look_at(Vector2(0, 0))
		bullet.rotation -= PI
		tween.interpolate_property(bullet, "position", Vector2(rand_range(550, 700), rand_range( - 350, 350)), Vector2(0, 0), 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.85, false), "timeout")
