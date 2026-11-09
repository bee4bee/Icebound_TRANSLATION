extends Node2D

onready var songText = $Song
onready var creditsText = $Credits

var tween = Tween.new()

func _ready():
	add_child(tween)


func _castNameplate(title, credits):
	songText.text = title
	creditsText.text = credits
	
	tween.interpolate_property(self, "position:x", position.x, position.x + 300, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(4.0, false), "timeout")
	tween.interpolate_property(self, "position:x", position.x, position.x - 300, 1.5, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()
	print(1)
