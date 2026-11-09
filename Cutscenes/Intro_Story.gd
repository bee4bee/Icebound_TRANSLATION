extends Node2D

onready var blitter = $Blitter
onready var cam = $Camera

var tween = Tween.new()
var tweenfade = Tween.new()

var index = 0.0
var canSkip = true

var dialogue = [
	"Между людьми и монстрами велась ожесточённая война. Монстры проиграли, и их запечатали под землёй.", 
	"Многие из них привыкли к этому. Другие нет, особенно те, кто находился у власти.", 
	"За спиной королевы Ториэль король АЗГОР и королевские учёные разработали план по разрушению барьера.", 
	"Были предприняты попытки создать искусственные ДУШИ, обладающие разными стихиями.", 
	"Всего их было сделано три: одна из Пламени, одна из Природы и одна из Мороза.", 
	"ДУША из Пламени оказалась слишком нестабильной, от чего она взорвалась почти сразу же.", 
	"ДУША Природы вянула и разлагалась, оставляя поросль на монстрах-добровольцах.", 
	"ДУША Мороза... сопротивлялась. После чего ей было дано название «Ледник».", 
	"Поскольку она была нестабильна по своей природе, АЗГОР искал хозяина, но не нашёл никого, кроме одного монстра...", 
	"...монстра в иссохшем плаще.", 
	"Но, несмотря на успешное слияние, эксперимент по-прежнему оставался нестабильным. Вскоре он был прекращён из-за некоего «исчезновения».", 
	"После этого, вместо него были начаты испытания РЕШИМОСТИ. По крайней мере... на некоторое время.", 
	"Несколько лет спустя упал седьмой Человек. Он проявлял ко всем милосердие, но... это было бесполезно. Он не смог пройти через барьер.", 
	"АЗГОР пал, а ДУШИ рассеялись. В это время, последний королевский ученый возился с экспериментом, выходящим далеко за рамки своих знаний.", 
	"«Ледник», вновь пробудившийся на свет, обрёл разум, шепча сладкую ложь о свободе...", 
	"...мгновение спустя он погрузил всё подземелье в хаос.", 
	"Мороз поглотил всё подземелье, погрузив его в бесконечную зиму и изолировав от времени.", 
	"...забрав с собой 75% от всех монстров.", 
	"СЕГОДНЯШНИЙ ДЕНЬ - 8 ЛЕТ СПУСТЯ", 
	"Падает ещё один Человек, оказавшись перед миром, стоящим на краю гибели.", 
	"И её ждёт только один путь впереди."
	
	
	
	
	
	
]

func _ready():
	add_child(tween)
	add_child(tweenfade)
	_scene_set()
	cam.darken_with_set_values(1.0, 0.0, 2.5)
	tweenfade.interpolate_property($Music, "volume_db", - 40.0, 0.0, 6.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	$Music.play()
	


func _process(delta):
	
	if tween.is_active():
		var pos = blitter.get_visible_characters()
		
		var getchar = blitter.text[blitter.visible_characters]
		if getchar != " " or getchar != "." or getchar != ",":
			$chatter_fx.play()
	

func _input(event):
	if Input.is_action_just_pressed("cutsceneskip"):
		set_process(false)
		_trans_to_menu()



func _scene_set():
	_create_text(dialogue[0])
	_scene_0()
	yield(get_tree().create_timer(7.0, false), "timeout")
	_fade_scene($Panels / Panel0)
	yield(get_tree().create_timer(2.0, false), "timeout")
	_scene_1_2()
	_create_text(dialogue[1])
	yield(get_tree().create_timer(6.0, false), "timeout")
	_create_text(dialogue[2])
	yield(get_tree().create_timer(8.0, false), "timeout")
	_fade_scene($Panels / Panel1_2)
	yield(get_tree().create_timer(2.0, false), "timeout")
	_create_text(dialogue[3])
	_scene_3_8()
	yield(get_tree().create_timer(6.0, false), "timeout")
	_create_text(dialogue[4])
	yield(get_tree().create_timer(6.0, false), "timeout")
	_create_text(dialogue[5])
	yield(get_tree().create_timer(6.0, false), "timeout")
	_create_text(dialogue[6])
	yield(get_tree().create_timer(7.0, false), "timeout")
	_create_text(dialogue[7])
	
	yield(get_tree().create_timer(6.0, false), "timeout")
	_fade_scene($Panels / Panel3_7)
	yield(get_tree().create_timer(2.0, false), "timeout")
	_scene_8_9()
	_create_text(dialogue[8])
	yield(get_tree().create_timer(8.0, false), "timeout")
	_create_text(dialogue[9])
	
	yield(get_tree().create_timer(6.0, false), "timeout")
	_create_text(dialogue[10])
	_scene_10_11()
	yield(get_tree().create_timer(11.0, false), "timeout")
	_create_text(dialogue[11])
	yield(get_tree().create_timer(7.0, false), "timeout")
	_fade_scene($Panels / Panel10_11)
	yield(get_tree().create_timer(2.0, false), "timeout")
	_create_text(dialogue[12])
	_scene_12_13()
	yield(get_tree().create_timer(10.0, false), "timeout")
	_create_text(dialogue[13])
	yield(get_tree().create_timer(9.0, false), "timeout")
	_fade_scene($Panels / Panel12_13)
	yield(get_tree().create_timer(2.0, false), "timeout")
	_create_text(dialogue[14])
	_scene_14_15()
	yield(get_tree().create_timer(7.0, false), "timeout")
	_create_text(dialogue[15])
	yield(get_tree().create_timer(5.0, false), "timeout")
	_create_text(dialogue[16])
	yield(get_tree().create_timer(9.0, false), "timeout")
	_create_text(dialogue[17])
	yield(get_tree().create_timer(5.0, false), "timeout")
	_create_text(dialogue[18])
	_scene_final()
	yield(get_tree().create_timer(5.0, false), "timeout")
	_create_text(dialogue[19])
	yield(get_tree().create_timer(7.0, false), "timeout")
	_create_text(dialogue[20])
	
	yield(get_tree().create_timer(6.0, false), "timeout")
	_fade_scene($Panels / Panelrest)
	
	yield(get_tree().create_timer(3.0, false), "timeout")
	_go_to_menu()

func _go_to_menu():
	if PlayerData.Name != "": get_tree().change_scene("res://Main Menu/MainMenu.tscn")
	else: get_tree().change_scene("res://NameSelection/NameSelection.tscn")

func _trans_to_menu():
	cam.darken_with_set_values(0.0, 1.0, 2.0)
	tweenfade.interpolate_property($chatter_fx, "volume_db", 0.0, - 80.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property($Music, "volume_db", 0.0, - 80.0, 4.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(3.0, false), "timeout")
	_go_to_menu()
	
func _create_text(text):
	blitter.text = text
	blitter.percent_visible = 0.0
	blitter.modulate.a = 1.0
	tween.interpolate_property(
		blitter, "percent_visible", 
		0.0, 1.0, len(text) * 0.06, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()

func _fade_scene(node):
	tweenfade.interpolate_property(
		blitter, "modulate:a", 
		1.0, 0.0, 1.0, 
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	tweenfade.interpolate_property(
		node, "modulate:a", 
		node.modulate.a, 0.0, 1.2, 
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	tweenfade.start()


func _scene_0():
	var panel = $Panels / Panel0
	panel.show()
	var background = $Panels / Panel0 / Background
	var asgore = $Panels / Panel0 / Asgore
	var human = $Panels / Panel0 / HumanKnight
	asgore.modulate.a = 0
	human.modulate.a = 0
	tweenfade.interpolate_property(panel, "position:x", 30, - 40, 5.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenfade.interpolate_property(background, "modulate:a", 0.0, 0.4, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweenfade.interpolate_property(asgore, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(asgore, "position:x", asgore.position.x, asgore.position.x - 30, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1, false), "timeout")
	tweenfade.interpolate_property(human, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(human, "position:x", human.position.x, human.position.x + 25, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()

func _scene_1_2():
	var background = $Panels / Panel1_2 / Background
	var asgore = $Panels / Panel1_2 / Asgore
	var alphys = $Panels / Panel1_2 / Alphys
	var gaster = $Panels / Panel1_2 / Gaster
	tweenfade.interpolate_property(background, "modulate:a", 0.0, 0.4, 5.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(background, "position:y", 260, 240, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(2.0, false), "timeout")
	tweenfade.interpolate_property(asgore, "modulate:a", 0.0, 1.0, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(asgore, "position:y", 250, 240, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(7.0, false), "timeout")
	tweenfade.interpolate_property(alphys, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(alphys, "position:x", 280, 320, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.0, false), "timeout")
	tweenfade.interpolate_property(gaster, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(gaster, "position:x", 420, 380, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()

func _scene_3_8():
	var soulice = $Panels / Panel3_7 / Soul
	var soulleft = $Panels / Panel3_7 / SoulLeft
	var soulright = $Panels / Panel3_7 / SoulRight
	var bg = $Panels / Panel3_7 / bg
	soulice.show()
	$Panels / Panel3_7 / Soul / AudioStreamPlayer.play()
	$Panels / Panel3_7 / Soul / Particles2D.emitting = true
	yield(get_tree().create_timer(3.5, false), "timeout")
	tweenfade.interpolate_property(soulice, "modulate:a", 1.0, 0.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(4.5, false), "timeout")
	tweenfade.interpolate_property(bg, "modulate:a", 0.0, 1.0, 8.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	soulleft.show()
	tweenfade.interpolate_property(soulleft, "position", soulleft.position, soulleft.position + Vector2( - 65, - 10), 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(soulleft, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.0, false), "timeout")
	soulright.show()
	tweenfade.interpolate_property(soulright, "position", soulright.position, soulright.position + Vector2(65, - 10), 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(soulright, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.0, false), "timeout")
	soulice.frame = 1
	tweenfade.interpolate_property(soulice, "position:y", soulice.position.y, 300, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(soulice, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Panels / Panel3_7 / Soul / emit.emitting = true
	tweenfade.start()
	yield(get_tree().create_timer(5.0, false), "timeout")
	for i in 8:
		if i % 2 == 0: soulleft.position.x += i * 1.5
		else: soulleft.position.x -= i * 1.5
		yield(get_tree().create_timer(0.04, false), "timeout")
	soulleft.hide()
	$Panels / Panel3_7 / explosion.emitting = true
	$Panels / Panel3_7 / explosion / AudioStreamPlayer.play()
	$Camera.add_trauma(0.6)
	yield(get_tree().create_timer(4.0, false), "timeout")
	tweenfade.interpolate_property(soulright.material, "shader_param/dissolve_value", 1.0, 0.0, 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tweenfade.start()
	yield(get_tree().create_timer(5.5, false), "timeout")
	soulright.hide()
	tweenfade.interpolate_property(soulice, "scale", soulice.scale, Vector2(4.5, 4.5), 4.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(soulice, "position:y", soulice.position.y, soulice.position.y - 20, 4.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(8.0, false), "timeout")
	$Panels / Panel3_7 / Soul.hide()

func _scene_8_9():
	var bg = $Panels / Panel8_9 / Bg
	var magick = $Panels / Panel8_9 / Magick
	var knight = $Panels / Panel8_9 / Knight
	var rp = $Panels / Panel8_9 / Riverp
	tweenfade.interpolate_property(bg, "modulate:a", 0.0, 1.0, 5.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(3.5, false), "timeout")
	tweenfade.interpolate_property(magick, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(magick, "position:y", magick.position.y + 40, magick.position.y, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(0.5, false), "timeout")
	tweenfade.interpolate_property(knight, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(knight, "position:y", knight.position.y + 40, knight.position.y, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(4.5, false), "timeout")
	tweenfade.interpolate_property(rp, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(rp, "position:y", rp.position.y + 30, rp.position.y, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(3.5, false), "timeout")
	_fade_scene($Panels / Panel8_9)

func _scene_10_11():
	var gaster = $Panels / Panel10_11 / Gaster
	var alphys = $Panels / Panel10_11 / Alphys
	var amalg = $Panels / Panel10_11 / Amalgam
	tweenfade.interpolate_property(alphys, "position:x", alphys.position.x + 60, alphys.position.x, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(alphys, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.2, false), "timeout")
	tweenfade.interpolate_property(gaster, "position:x", gaster.position.x - 60, gaster.position.x, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(gaster, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(4.2, false), "timeout")
	tweenfade.interpolate_property(gaster, "position:x", gaster.position.x, gaster.position.x + 600, 3.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tweenfade.interpolate_property(gaster, "modulate:a", 1.0, 0.0, 3.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tweenfade.start()
	
	yield(get_tree().create_timer(5.6, false), "timeout")
	tweenfade.interpolate_property(alphys, "scale", alphys.scale, Vector2(1.5, 1.5), 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	
	yield(get_tree().create_timer(3.0, false), "timeout")
	tweenfade.interpolate_property(amalg, "modulate:a", 0.0, 0.6, 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenfade.start()

func _scene_12_13():
	var frisk = $Panels / Panel12_13 / Frisk
	var bg = $Panels / Panel12_13 / bg
	var buttons = $Panels / Panel12_13 / Light2D
	tweenfade.interpolate_property(bg, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweenfade.interpolate_property(bg, "position:x", bg.position.x + 35, bg.position.x, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.6, false), "timeout")
	tweenfade.interpolate_property(frisk, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(frisk, "position:x", frisk.position.x + 65, frisk.position.x, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(1.5, false), "timeout")
	tweenfade.interpolate_property(buttons, "energy", 0.0, 3.2, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(buttons, "position:x", buttons.position.x - 65, buttons.position.x, 1.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	
	yield(get_tree().create_timer(10.0, false), "timeout")
	tweenfade.interpolate_property($Panels / Panel12_13, "modulate:a", 1.0, 0.0, 2.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(2.5, false), "timeout")
	$Panels / Panel12_13.hide()

func _scene_14_15():
	var rp = $Panels / Panel14_15 / AnimatedSprite
	tweenfade.interpolate_property(rp, "modulate:a", 0.0, 1.0, 3.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(rp, "scale", Vector2(2.5, 2.5), rp.scale, 3.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(7.0, false), "timeout")
	tweenfade.interpolate_property(rp, "modulate:a", 1.0, 0.4, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(rp, "scale", Vector2(2, 2), Vector2(2.8, 2.8), 1.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(2.0, false), "timeout")
	$Camera.flash(2.0)
	$Camera.add_trauma(0.6)
	rp.frame = 1
	tweenfade.interpolate_property(rp, "modulate:a", 0.4, 1.0, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(rp, "scale", rp.scale, Vector2(2, 2), 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	
	yield(get_tree().create_timer(8.0, false), "timeout")
	tweenfade.interpolate_property(rp, "modulate:a", 1.0, 0.0, 7.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenfade.start()

func _scene_final():
	var chione = $Panels / Panelrest / Chione
	var bg = $Panels / Panelrest / bg
	tweenfade.interpolate_property(bg, "modulate:a", 0.0, 1.0, 4.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(bg, "scale", Vector2(3.5, 3.5), Vector2(2.2, 2.2), 4.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(5.3, false), "timeout")
	tweenfade.interpolate_property(chione, "modulate:a", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.interpolate_property(chione, "position:y", chione.position.y - 75, chione.position.y, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenfade.start()
	yield(get_tree().create_timer(3.5, false), "timeout")
	tweenfade.interpolate_property($Panels / Panelrest, "modulate:a", 1.0, 0.0, 3.5, Tween.TRANS_QUINT, Tween.EASE_IN)
	tweenfade.start()
