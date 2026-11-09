extends Control


onready var box = $NinePatchRect
onready var blitter = $Text
var tween = Tween.new()

var index = 0.0
export var maxIndex = 0.0
export var currentIndex = 0.0
export var isActive = false

onready var spr = $AnimatedSprite
onready var timer = $Timer

var char_count

var pause = {}
var pause_count = 0

func _ready():
	self.hide()
	add_child(tween)
	
	box.rect_size = Vector2(50, 150)
	modulate.a = 0.0

func _process(delta):
	$aster.add_font_override("normal_font", blitter.get("custom_fonts/normal_font"))
	
	_base_resize()

func _create_box(arrayText, showIndex, anim, frame, toTheRight: bool = false):
	isActive = true
	self.show()
	tween.interpolate_property(box, "rect_size:x", 50, 560, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(box, "rect_position:x", 280, 40, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not toTheRight: tween.interpolate_property(spr, "position:x", 300, 120, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	else:
		tween.interpolate_property(spr, "position:x", 400, 480, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
		spr.scale.x = - 2.2
	tween.interpolate_property(spr, "modulate:a", 0, 1, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	_create_text(arrayText, showIndex, anim, frame)
	$aster.show()
	tween.start()
	
	spr.animation = anim[showIndex]
	spr.frame = frame[showIndex]

func _create_text(arrayText, showIndex, anim, frame):
	blitter.visible_characters = 0
	blitter.bbcode_text = arrayText[showIndex]
	
	yield(get_tree().create_timer(0.05, false), "timeout")
	
	timer.start()
	
	_setFonts(anim[showIndex])
	spr.animation = anim[showIndex]
	spr.frame = frame[showIndex]

func _on_Timer_timeout():
	if len(blitter.bbcode_text) > blitter.visible_characters:
		
		blitter.visible_characters += 1
		char_count = blitter.visible_characters
		
		var getchar = blitter.text[char_count - 1]
		if getchar == " " or getchar == "." or getchar == ",": pass
		else:
			$Blitter_Sound.play()
			$Blitter_Sound.pitch_scale = rand_range(0.98, 1.02)
		
		if not pause.empty():
			if char_count == pause.keys()[pause_count]:
				timer.wait_time = pause.values()[pause_count]
				if pause.size() - 1 > pause_count:
					pause_count += 1
			else:
				timer.wait_time = 0.04
		
		
		timer.start()
		
	else: timer.stop()

func _setFonts(anim):
	var font = DynamicFont.new()
	font.use_filter = false
		
	if anim == "ch" or anim == "fr" or anim == "0" or anim == "sbt" or anim == "arch":
		font.font_data = load("res://determination-mono-web-font/DeterminationMonoWebRegular-Z5oq.ttf")
		font.size = 30
		
		$Blitter_Sound.stream = load("res://music/chatter/SND_TXT2.wav")
		$aster.show()
		ispapyrus = 0
		if anim == "sbt":
			font.extra_spacing_char = 2
	
	if anim == "fl":
		font.font_data = load("res://determination-mono-web-font/DeterminationMonoWebRegular-Z5oq.ttf")
		font.size = 30
		$Blitter_Sound.stream = load("res://music/chatter/snd_floweytalk1.wav")
		
	if anim == "s":
		font.font_data = load("res://determination-mono-web-font/pixel-comic-sans-undertale-sans-font.ttf")
		font.size = 30
		$Blitter_Sound.stream = load("res://music/chatter/voice_Sans.wav")
	
	if anim == "pap":
		font.font_data = load("res://determination-mono-web-font/papyrus.ttf")
		$Blitter_Sound.stream = load("res://music/chatter/voice_Papyrus.wav")
		$aster.hide()
		ispapyrus = 10
		font.size = 25
		
	blitter.add_font_override("normal_font", font)


var ispapyrus = 0

func _remove_box():
	pause = {}
	isActive = false
	currentIndex = 0.0
	tween.remove_all()
	blitter.bbcode_text = " "
	$aster.hide()
	
	tween.interpolate_property(box, "rect_size:x", 560, 50, 0.85, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(box, "rect_position:x", 40, 280, 0.85, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.05, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(spr, "position:x", spr.position.x, spr.position.x + 20 * spr.scale.x, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(spr, "modulate:a", 1, 0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _base_resize():
	box.rect_pivot_offset = box.rect_size / 2
	$aster.rect_position = box.rect_position + Vector2(30, 15)
	blitter.rect_position = box.rect_position + Vector2(60, 18) - Vector2(ispapyrus, 0)
	blitter.rect_size = box.rect_size - Vector2(70, 30) + Vector2(ispapyrus, 0)



