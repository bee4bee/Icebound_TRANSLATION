extends Node2D


onready var tween = $Tween

onready var chione = $ChionePlayer
onready var paps = $Papyrus_overworld

onready var textbox = $TextBox
onready var camera = $Camera
onready var trans = $TransitionScreen
var canTrans = true

var canCastDialogue = false
func _ready():
	$Camera.darken_with_set_values(1.0, 0.0, 4.0)
	trans.set_process(false)
	
	
	$Pattern.modulate.a = 0.0
	
	$TransitionScreen / Soul.position = chione.position
	
	$Camera.position.x = 320
	
	RichPresence._update_activity("Snowdin Overworld", "Cherryside Town")

	tween.interpolate_property(
		$PreEncounter_track, "volume_db", 
		- 35.0, 0.0, 3.0, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()
	$PreEncounter_track.playing = true
	PlayerData.items = ["Цвет. венок", "Кусок снега", "Пирог", "..."]
	PlayerData.currentArea = get_tree().current_scene.filename
	PlayerData._save_game()
	
	chione.position.x = - 10
	chione.position.y -= 15
	paps.position.x -= 15
	chione.get_node("AnimatedSprite").animation = "right"
	chione.get_node("AnimatedSprite").playing = false
	chione.get_node("AnimatedSprite").frame = 1
	chione.canMove = false
	
	tween.interpolate_property(
		$Camera, "position:x", 
		$Camera.position.x, chione.position.x + 190, 1.0, 
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	textbox._create_box(dialArray, 0, expr, frame, true)
	canCastDialogue = true

var index = 0.0
var currentInd = 0

func _process(delta):
	

	$TransitionScreen / Soul.position = chione.position
	trans.position = $Camera.position - Vector2(320, 240)
	for iteration in $Pattern.get_children():
		iteration.rect_position.x -= 10 * delta
		if iteration.rect_position.x < - 320:
			iteration.rect_position.x = 636
	
	textbox.rect_position.x = camera.position.x - 320
	textbox.rect_position.y = camera.position.y + 60
	
	if chione.canMove == true and chione.position.x >= - 320 and chione.position.x <= 260:
		tween.interpolate_property(
			$Camera, "position:x", 
			$Camera.position.x, chione.position.x, 1.0, 
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
		tween.start()
	
	if canCastDialogue: cast_dialogue()
	
	_collide_and_display()

func _collide_and_display():
	var collider
	if $VegetationBack / LampPostSnd / Area2D.get_overlapping_areas():
		collider = $VegetationBack / LampPostSnd
		_show_box_text(collider)
	if $VegetationBack / FriskSnowdin / Area2D.get_overlapping_areas():
		collider = $VegetationBack / FriskSnowdin
		_show_box_text(collider)

func _show_box_text(collider):
	if Input.is_action_just_pressed("ui_accept"):
		textbox.maxIndex = collider.lineIndex
		if textbox.isActive == true:
			textbox.currentIndex += 1
			print(1)
			if textbox.currentIndex <= textbox.maxIndex:
				textbox._create_text(collider.blitter, textbox.currentIndex)
			else:
				textbox._remove_box()
				
				camera.darken_with_set_values(0.0, 1.0, 4.0)
				yield(get_tree().create_timer(4.5), "timeout")
				get_tree().change_scene("res://Cutscenes/CutsceneWaterfall.tscn")
				
		elif textbox.isActive == false:
			chione._react(1)
			chione.canMove = false
			textbox._create_box(collider.blitter, 0)


var dialArray = [
	"Я  С  САМОГО  НАЧАЛА  ЗНАЛ,  ЧТО  ТЫ  СИЛЬНЫЙ  ЧЕЛОВЕК!", 
	"КОРОЛЕВСКАЯ  СТРАЖА  НИКОГДА  НЕ  УПУСКАЕТ  ТАКОЙ  ПОТЕНЦИАЛ!", 
	"ПРОЙДЯ  МОЁ  ИСКУСНО  СОЗДАННОЕ  ИСПЫТАНИЕ,  ТЫ ПОКАЗАЛА,  ЧТО...", 
	"...ТЫ  ГОТОВА  ОТПРАВЛЯТЬСЯ  ВПЕРЁД!...", 
	"...ПОЛНОСТЬЮ... САМОСТОЯТЕЛЬНО!", 
	"Надо же, похоже, ты и вправду победила Папируса.", 
	"Что я говорил? Он слишком лёгкий~", 
	"...", 
	"...Эй, Папс, молчать - это не в твоём стиле...", 
	"Что-то случилось? Что-то не так?", 
	"ОУ,  НЕ  ОБРАЩАЙ  ВНИМАНИЯ!  Я  КОЕ-ЧТО ОСОЗНАЛ!  НЬЕХ-ХЕХ.", 
	"ЧЕЛОВЕК!  Я  ДОРОЖИЛ  ВСЕМ  ВРЕМЕНЕМ,  ЧТО  МЫ  ПРОВЕЛИ  ВМЕСТЕ!", 
	"НО  ТЕПЕРЬ  ТЕБЯ  ЖДЁТ  ТРУДНОЕ  И  ПУГАЮЩЕЕ  ПУТЕШЕСТВИЕ.", 
	"НО  НЕ  ВОЛНУЙСЯ!  Я  ВСЁ  РАВНО  БУДУ  РЯДОМ  С  ТОБОЙ!", 
	"А у меня просто нет другого выбора."
]

var expr = ["pap", "pap", "pap", "pap", "pap", "fr", "fr", "fr", "fr", "fr", "pap", "pap", "pap", "pap", "fr"]
var frame = [0, 1, 0, 0, 3, 0, 0, 1, 1, 1, 0, 2, 2, 1, 0]

func cast_dialogue():
	var dynamic_font = DynamicFont.new()
	
	if currentInd == 0:
		
		
		
		
		pass
	
	if Input.is_action_just_pressed("ui_accept"):
		currentInd += 1
		match currentInd:
			1: _papyrusglitter()
			2: _papyrusstatic()
			5:
				tween.interpolate_property($frisk, "position:x", $frisk.position.x, $frisk.position.x + 80, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.start()
				$ChionePlayer / AnimatedSprite.animation = "falling"
				$ChionePlayer / AnimatedSprite.frame = 4
				$ChionePlayer.scale.x *= - 1
			7: $frisk.frame = 1
			8:
				$ChionePlayer.scale.x *= - 1
				$ChionePlayer / AnimatedSprite.animation = "right"
				$ChionePlayer / AnimatedSprite.frame = 1
			
		textbox.get_child(1).add_font_override("normal_font", dynamic_font)
		
		if currentInd >= dialArray.size():
			
			textbox._remove_box()
			canCastDialogue = false
			dynamic_font.font_data = load("res://determination-mono-web-font/DeterminationMonoWebRegular-Z5oq.ttf")
			camera.darken_with_set_values(0.0, 1.0, 5.0)
			tween.interpolate_property($PreEncounter_track, "volume_db", 0.0, - 80.0, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			yield(get_tree().create_timer(5.5), "timeout")
			get_tree().change_scene("res://Cutscenes/CutsceneWaterfall.tscn")
		if currentInd < dialArray.size():
			textbox._create_text(dialArray, currentInd, expr, frame)


func _start_battle():
	if canTrans:
		PlayerData.finishedAreas[0] = true
		trans._boot()
		trans.show()
		canTrans = false
		trans.scene_change = "res://Encounters/Papyrus_Snowdin/SnowdinEncounter.tscn"
		print(1)

func _papyrusglitter():
	paps.get_child(0).animation = "glitter"
	paps.get_child(0).playing = true

func _papyrusstatic():
	paps.get_child(0).animation = "static_shade"
	paps.get_child(0).playing = false
	paps.get_child(0).frame = 3
