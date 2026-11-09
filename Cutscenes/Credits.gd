extends Node2D

var tw = Tween.new()

func _ready():
	
	if not PlayerData.addParticles: $Particles2D.emitting = false
	$music.play()
	add_child(tw)
	yield(get_tree().create_timer(22.0), "timeout")
	$Camera.darken_with_set_values(0.0, 1.0, 6.5)
	yield(get_tree().create_timer(9.0), "timeout")
	$Camera.darken_with_set_values(1.0, 0.0, 1.2)
	
	tw.interpolate_property($Title, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.interpolate_property($Title, "position:y", $Title.position.y, 240, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
	
	yield(get_tree().create_timer(1.8), "timeout")
	tw.interpolate_property($All, "position:y", $All.position.y, $All.position.y - 4400, 140.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	
	yield(get_tree().create_timer(5.0), "timeout")
	tw.interpolate_property($Title, "position:y", $Title.position.y, $Title.position.y - 4400, 150.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	
	yield(get_tree().create_timer(85.0), "timeout")
	tw.interpolate_property($end, "rect_position:y", 500, 160, 2.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(10.0), "timeout")
	$Camera.darken_with_set_values(0.0, 1.0, 6.5)
	yield(get_tree().create_timer(9.5), "timeout")
	get_tree().change_scene("res://Main Menu/MainMenu.tscn")
