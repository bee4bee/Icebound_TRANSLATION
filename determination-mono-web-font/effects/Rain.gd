tool 
extends RichTextEffect



var bbcode = "rain"
var val = []

func _ready():
	for i in 100:
		val[i] = rand_range( - 8.0, 8.0)

func get_rand(char_fx):
	return fmod(get_rand_unclamped(char_fx), 1.0)


func get_rand_unclamped(char_fx):
	return char_fx.character * 33.33 + char_fx.absolute_index * 4545.5454


func _process_custom_fx(char_fx):
	var time = char_fx.elapsed_time
	var r = get_rand(char_fx)
	
	var t = fmod(r + time * 0.25, 1.0)
	char_fx.offset.y += t * 8.0
	
	char_fx.color = lerp(char_fx.color, Color.transparent, t)
	return true
