extends Node2D

onready var blitter = $Blitter
onready var ending = $Ending

var textArray = [
	"You attempt to offer Sans mercy, a way to end this without violence. ", 
	"However, his goals are different, veiling such options beyond his sight. ", 
	"You die soon after his strike. "
]

var tween = Tween.new()
var timer = 0.0
var isWritingEnd = false

func _ready():
	$Camera / ColorRect.modulate = Color(0, 0, 0, 1)
	add_child(tween)
	$Camera.darken_with_set_values(1.0, 0.0, 2.5)
	blitter.percent_visible = 0.0
	ending.percent_visible = 0.0

func _process(delta):
	timer += 1
	
	if tween.is_active():
		var pos = blitter.get_visible_characters()
		if blitter.bbcode_text.length() > pos and blitter.bbcode_text[pos] != " ":
			$snd.play()
		if isWritingEnd:
			var posend = ending.get_visible_characters()
			if ending.bbcode_text.length() > posend and ending.bbcode_text[pos] != " ":
				$snd.play()
	
	if timer == 10:
		blitter.percent_visible = 0.0
		interpolate_text(0)
	
	if timer == 165: interpolate_visibility()
	
	if timer == 220:
		$ColorRect.material.set("shader_param/shake_rate", 0.8)
	if timer == 235:
		blitter.modulate.a = 1.0
		blitter.percent_visible = 0.0
		interpolate_text(1)
	
	if timer == 240:
		$AnimatedSprite.frame = 2
		$Camera.add_trauma(0.6)
		$damage.play()
	
	if timer == 250:
		$ColorRect.material.set("shader_param/shake_rate", 0.02)
	
	if timer == 395:
		interpolate_visibility()
		tween.interpolate_property(
			$AnimatedSprite, "modulate:a", 
			1.0, 0.0, 2.0, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
	
	if timer == 485:
		$ColorRect.material.set("shader_param/shake_rate", 0.0)
		isWritingEnd = true
		tween.interpolate_property(
			ending, "percent_visible", 
			0.0, 1.0, len(ending.bbcode_text) * 0.04, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
	
func interpolate_text(entry):
	blitter.bbcode_text = textArray[entry]
	tween.interpolate_property(
		blitter, "percent_visible", 
		0.0, 1.0, len(blitter.bbcode_text) * 0.04, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

func interpolate_visibility():
	tween.interpolate_property(
		blitter, "modulate:a", 
		1.0, 0.0, 1.0, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()
