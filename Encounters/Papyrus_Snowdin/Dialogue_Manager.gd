extends Control


onready var bubble = $Text_Bubble
onready var blitter = $Blitter
onready var text_tween = $Tween

var dialogue = []
var papyrusHead = []

onready var papyrusHeadSpr = get_node("/root/Battle_Engine/papyrus/Idle/Head")

var char_read = 0.04
var index = 0
var is_dialogue_current_instance_finished = false

var isCastedFromMain = false
signal dialogue_finished

func _ready():
	
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and isCastedFromMain:
		_cast_dialogue()
	
	if text_tween.is_active():
		var pos = blitter.get_visible_characters()
		if blitter.bbcode_text.length() > pos and blitter.bbcode_text[pos] != " ":
			$papChatter.play()
			$papChatter.pitch_scale = rand_range(0.98, 1.02)

func _cast_dialogue():
	isCastedFromMain = true
	if index < dialogue.size():
		
		blitter.bbcode_text = dialogue[index]
		blitter.percent_visible = 0.0
		text_tween.remove_all()
		text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * char_read, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		text_tween.start()
		
		papyrusHeadSpr.frame = papyrusHead[index]
	
	else:
		emit_signal("dialogue_finished")
		self.set_process(false)
		self.hide()
		
	index += 1


func _cast_dialogue_inbattle(dialog):
	blitter.bbcode_text = dialog
	blitter.percent_visible = 0.0
	self.show()
	self.set_process(true)
	isCastedFromMain = false
	text_tween.remove_all()
	text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * char_read, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_tween.start()


func _on_Battle_Engine_enemy_turn_dialogue(turn_count):
	index = 0
	if turn_count == 1:
		
		if not PlayerData.SnowdinDeath:
			dialogue = [
				"ЧЕЛОВЕК! ЭТО БУДЕТ ПОСЛЕДНЕЕ ИСПЫТАНИЕ, ЧТОБЫ ДОКАЗАТЬ МНЕ, ВЕЛИКОМУ ПАПИРУСУ. . .", 
				"ЧТО ТЫ ДОСТАТОЧНО СИЛЬНА, ЧТОБЫ ЗАЩИТИТЬ СЕБЯ БЕЗ МОЕЙ ПОМОЩИ!", 
				"Я НЕ БУДУ ЦЕРЕМОНИТЬСЯ С ТОБОЙ! Я БРОШУ НА ТЕБЯ ВСЕ СВОИ СИЛЫ, ЧТОБЫ ОДОЛЕТЬ!", 
				"ЕСЛИ ТЫ ПЕРЕЖИВЁШЬ ЭТИ АТАКИ. . .", 
				"Я ПРОПУЩУ ТЕБЯ, И МЫ СМОЖЕШЬ ПОЙТИ В ВОДОПАДЬЕ.", 
				"ТЫ ГОТОВА? ПОТОМУ ЧТО Я УВЕРЕН В ТОМ, ЧТО ЭТО НЕ БУДЕТ ТАК ПРОСТО ДЛЯ ТЕБЯ!", 
				"УДАЧИ! НЬЕХ-ХЕХ-ХЕ!!", 
			]
			papyrusHead = [1, 1, 1, 2, 0, 2, 1]
		
		if PlayerData.SnowdinDeath:
			dialogue = ["ГОТОВА?"]
			papyrusHead = [1]
	self.set_process(true)
	self.show()
	index = 0
	_cast_dialogue()
	
