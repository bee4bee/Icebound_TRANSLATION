extends Node2D


onready var tween = $Tween

onready var chione = $ChionePlayer
onready var paps = $Papyrus_overworld

onready var textbox = $TextBox
onready var camera = $Camera
onready var trans = $TransitionScreen
var canTrans = true


func _ready():
	OS.set("rendering/2d/snapping/use_gpu_pixel_snap", true)
	$Camera.darken_with_set_values(1.0, 0.0, 4.0)
	trans.set_process(false)
	
	paps.modulate.a = 0.0
	$Pattern.modulate.a = 0.0
	
	$TransitionScreen / Soul.position = chione.position
	
	$Camera.position.x = - 320
	$Camera._castNameplate("Вишнёвая тропа", "Конец Снежграда\nМузыку сделал: Mugger")
	
	RichPresence._update_activity("Snowdin Overworld", "Cherryside Town")

	tween.interpolate_property($PreEncounter_track, "volume_db", - 35.0, 0.0, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$PreEncounter_track.playing = true
	PlayerData.items = ["Цвет. венок", "Кусок снега", "Пирог", "..."]
	PlayerData.currentArea = get_tree().current_scene.filename
	PlayerData._save_game()
	
	if PlayerData.SnowdinDeath: ind = 1
	
	if not PlayerData.addLights:
		$"lights n stuff/Light2D8".energy = 0
		$"lights n stuff/Light2D7".energy = 0
		$"lights n stuff/Light2D6".energy = 0
	
	if not PlayerData.addParticles: $Particles2D.amount /= 2

var index = 0.0
var currentInd = 0.0
var canCastDialogue = false

func _process(delta):
	
	paps.position.y = chione.position.y - 26
	$TransitionScreen / Soul.position = chione.position
	trans.position = $Camera.position - Vector2(320, 240)
	
	$Pattern / FlakePattern.rect_position.x -= 10 * delta
	$Pattern / FlakePattern.rect_size.x += 10 * delta
	
	textbox.rect_position = camera.position - Vector2(320, - 60)
	
	if chione.position.x >= - 140:
		$Pattern.modulate.a = (100 - ((160 - chione.position.x) / 3)) / 100
	
	if chione.canMove == true and chione.position.x >= - 320:
		tween.interpolate_property($Camera, "position:x", $Camera.position.x, chione.position.x, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		$Pattern.position.x = camera.position.x - 360
	
	if canCastDialogue: cast_dialogue()
	
	_collide_and_display()


func _on_EncounterCheck_area_entered(area):
	_papyrus_cutscene()
	$EncounterCheck.queue_free()

func _papyrus_cutscene():
	tween.interpolate_property($PreEncounter_track, "volume_db", 0.0, - 65.0, 4.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	$ChionePlayer / AnimatedSprite.animation = "static_shade"
	chione.canMove = false
	chione.modulate.a = 0.0
	move_child(chione, 7)
	chione.position.x = 159
	
	
	tween.interpolate_property($Camera, "position:x", $Camera.position.x, $Camera.position.x + 200, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(4.0, false), "timeout")
	$PreEncounter_track.playing = false
	SnowdinMusicSingleton._play_music()
	$Tween.interpolate_property(chione, "modulate:a", 0.0, 1.0, 2.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(2.5, false), "timeout")
	$Tween.interpolate_property(paps, "modulate:a", 0.0, 1.0, 2.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(2.5, false), "timeout")
	textbox._create_box(dialArray, 0, expr, frame, true)
	canCastDialogue = true

func _collide_and_display():
	var collider
	if $VegetationBack / LampPostSnd / Area2D.get_overlapping_areas():
		collider = $VegetationBack / LampPostSnd
		_show_box_text(collider)
		
	if $VegetationBack / FriskSnowdin / Area2D.get_overlapping_areas():
		collider = $VegetationBack / FriskSnowdin
		if collider.x == - 2: collider.x = 0
		if collider.x == - 1: collider._gen()
		match collider.x:
			0:
				collider.lineIndex = collider.lineIndex1
				collider.blitter = collider.blitter1
			1:
				collider.lineIndex = collider.lineIndex2
				collider.blitter = collider.blitter2
			2:
				collider.lineIndex = collider.lineIndex3
				collider.blitter = collider.blitter3
		
		_show_box_text(collider)
	
	if textbox.isActive:
		$ChionePlayer / AnimatedSprite.frame = 1
		$ChionePlayer / AnimatedSprite.playing = false

func _show_box_text(collider):
	if Input.is_action_just_pressed("ui_accept"):
		textbox.maxIndex = collider.lineIndex
		if textbox.isActive == true:
			textbox.currentIndex += 1
			if textbox.currentIndex <= textbox.maxIndex:
				textbox._create_text(collider.blitter, textbox.currentIndex, collider.expr, collider.exprFrame)
			else:
				textbox._remove_box()
				chione.canMove = true
				$VegetationBack / FriskSnowdin.x = - 1
		elif textbox.isActive == false:
			chione._react(1)
			chione.canMove = false
			textbox._create_box(collider.blitter, 0, collider.expr, collider.exprFrame)

var expr = ["pap", "pap", "pap", "pap", "pap", "pap", "pap", "pap", "pap", "pap"]
var frame = [0, 1, 3, 3, 1, 2, 1, 1, 1, 2]

var dialArray = [
	"ЧЕЛОВЕК!   ТЫ ПРИШЛА!", 
	"Я  НАДЕЮСЬ,   ЧТО  ВИДЫ  ВИШНЁВОЙ  ТРОПЫ  СМОГЛИ  ПОДНЯТЬ  ТЕБЕ  НАСТРОЕНИЕ!", 
	"ТЕПЕРЬ,  ТЫ   ДОЛЖНА   УЙТИ.", 
	"ТАКОВА  СУДЬБА  ВСЕХ  ЛЮДЕЙ,   ПОПАВШИХ   СЮДА.", 
	"НО   НЕ   ПЕРЕЖИВАЙ!", 
	"Я,   СТРАЖ   КОРОЛЕВСКОЙ   ГВАРДИИ,  БУДУ  СОПРОВОЖДАТЬ  ТЕБЯ  В  ДОРОГЕ  ДОМОЙ!", 
	"ОДНАКО  НАСТАЛО   ВРЕМЯ   ДЛЯ   ФИНАЛЬНОЙ   ГОЛОВОЛОМКИ!", 
	"ЭТА  ГОЛОВОЛОМКА  НАСТОЛЬКО   ВЕЛИКОЛЕПНА,   ЧТО  ОНА  ДАЖЕ  ВЕЛИКОЛЕПНЕЕ  МЕНЯ  САМОГО. . .", 
	"ЭТО  ИСПЫТАНИЕ  ЗАСТАВИТ  ТЕБЯ  ДРОЖАТЬ  ОТ  СТРАХА!", 
	"СОЗДАННОЕ  МНОЙ  -  ВЕЛИКИМ   ПАПИРУСОМ!   НЬЕХ-ХЕХ-ХЕ!!!"
]

var dial2 = [
	"HUMAN! YOU'VE ARRIVED!"
]

var ind = 10

func cast_dialogue():
	if Input.is_action_just_pressed("ui_accept"):
		if PlayerData.SnowdinDeath: ind = 1
		currentInd += 1
		if currentInd >= ind:
			tween.interpolate_property(
				$Camera, "zoom", 
				$Camera.zoom, Vector2(0.8, 0.8), 1.0, 
				Tween.TRANS_QUINT, Tween.EASE_OUT
			)
			tween.start()
			
			_start_battle()
		if currentInd < ind:
			if PlayerData.SnowdinDeath: textbox._create_text(dial2, currentInd, expr, frame)
			else: textbox._create_text(dialArray, currentInd, expr, frame)


func _start_battle():
	if canTrans:
		
		trans._boot()
		trans.show()
		canTrans = false
		trans.scene_change = "res://Encounters/Papyrus_Snowdin/SnowdinEncounter.tscn"
		print(1)




