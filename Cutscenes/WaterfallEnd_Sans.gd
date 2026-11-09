extends Node2D

onready var textbox = $TextBox
onready var panel = $Panel

onready var sans = $Panel / Sans
onready var flowey = $Panel / Flowey

var dialog = [
	"Похоже, Фриск наконец-то пришёл за Чионей.", 
	"Не в самый удачный момент.", 
	"...", 
	"Эй, мусорный мешок! Это не входило в наши планы!", 
	"давай без шуток.", 
	"Ух, мы совсем вымотались! Нам нужно бежать, чтобы восстановиться!", 
	"расслабься, ничего страшного.", 
	"одна фигура на шахматной доске сбита.", 
	"Да-да, всё равно! Нам нужно уйти до прихода Папируса!", 
	"Он доставит нам неприятностей!", 
	"ладно, я пойду с тобой.", 
	"но, знай вот что, подружка:", 
	"твои дни сочтены.", 
	"...", 
	"Санс и Флауи убежали."
]

var cnt = 0

var tween = Tween.new()

var expr = ["0", "0", "0", "fl", "s", "fl", "s", "s", "fl", "fl", "s", "s", "sbt", "0", "0"]
var frame = [0, 0, 0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 0, 0, 0]

func _ready():
	textbox._create_box(dialog, 0, expr, frame)
	add_child(tween)
	$Camera.darken_with_set_values(1.0, 0.0, 1.6)
	textbox.get_child(4).stream = load("res://music/chatter/SND_TXT2.wav")
	$music.playing = true
	tween.interpolate_property($music, "volume_db", - 80.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and cnt <= 14:
		cnt += 1
		
		match cnt:
			0, 1, 2, 3, 5, 8, 9:
				if cnt > 2:
					tween.interpolate_property(flowey, "modulate", flowey.modulate, Color(1, 1, 1), 0.6, tween.TRANS_QUINT, Tween.EASE_OUT)
					tween.interpolate_property(sans, "modulate", sans.modulate, Color(0.5, 0.5, 0.5), 0.6, tween.TRANS_QUINT, Tween.EASE_OUT)
			4, 6, 7, 10, 11, 12:
				tween.interpolate_property(flowey, "modulate", flowey.modulate, Color(0.5, 0.5, 0.5), 0.6, tween.TRANS_QUINT, Tween.EASE_OUT)
				tween.interpolate_property(sans, "modulate", sans.modulate, Color(1, 1, 1), 0.6, tween.TRANS_QUINT, Tween.EASE_OUT)
				
		match cnt:
			5, 9: flowey.frame = 1
			8: flowey.frame = 2
			14: $AudioStreamPlayer.play()
		
		if cnt == 13:
			tween.interpolate_property(panel, "modulate:a", 1.0, 0.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
		
		if cnt != 15:
			textbox._create_text(dialog, cnt, expr, frame)
			tween.start()
	
	if Input.is_action_just_pressed("ui_accept") and cnt == 15: _end()


func _end():
	textbox._remove_box()
	tween.interpolate_property($music, "volume_db", 0.0, - 80.0, 4.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(4.0, false), "timeout")
	get_tree().change_scene("res://Cutscenes/Credits.tscn")
