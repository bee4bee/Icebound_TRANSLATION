extends Node2D





onready var tween = $Tween


func _ready():
	
	if not PlayerData.addLights:
		$Sprite.hide()
		$Sprite2.hide()
	
	for i in 100000:
		tween.remove_all()
		tween.interpolate_property(
			$back, "rect_position:y", 
			$back.rect_position.y, $back.rect_position.y + 30, 0.8, 
			Tween.TRANS_BACK, Tween.EASE_IN_OUT
		)
		
		tween.interpolate_property(
			$front, "rect_position:y", 
			$front.rect_position.y, $front.rect_position.y - 20, 0.8, 
			Tween.TRANS_BACK, Tween.EASE_IN_OUT
		)
		
		tween.interpolate_property(
			$Sprite, "color:a", 
			0.5, 0.0, 1.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.interpolate_property(
			$Sprite2, "color:a", 
			0.5, 0.0, 1.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
	
		yield(get_tree().create_timer(1.0, false), "timeout")
	
		tween.remove_all()
		tween.interpolate_property(
			$back, "rect_position:y", 
			$back.rect_position.y, $back.rect_position.y - 30, 0.8, 
			Tween.TRANS_BACK, Tween.EASE_IN_OUT
		)
		
		tween.interpolate_property(
			$front, "rect_position:y", 
			$front.rect_position.y, $front.rect_position.y + 20, 0.8, 
			Tween.TRANS_BACK, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			$Sprite2, "color:a", 
			0.5, 0.0, 1.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
		
		yield(get_tree().create_timer(1.0, false), "timeout")

