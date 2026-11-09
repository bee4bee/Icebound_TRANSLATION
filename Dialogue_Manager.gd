extends Control


onready var bubble = $Text_Bubble
onready var blitter = $Blitter
onready var text_tween = $Tween

var dialogue = []
var charSpeaker = []
var sansHead = []
var floweyHead = []
var sansHand = []

var char_read = 0.04
export var line_index = 0
var is_dialogue_current_instance_finished = false

onready var sprite_preload = get_node("/root/Battle_Engine/Battle_Sprites")
var sans_sprite
var sansHeadSpr
var sans_posx
var sans_posy
var sanshandspr


var flowey_sprite
var floweyHeadSpr
var flowey_posx
var flowey_posy

signal dialogue_finished

func _ready():
	
	sans_sprite = sprite_preload.get_child(0)
	flowey_sprite = sprite_preload.get_child(1)
	
	sanshandspr = sans_sprite.get_node("Sans_HandRight")
	sansHeadSpr = sans_sprite.get_child(5)
	floweyHeadSpr = flowey_sprite.get_child(1)
	
	sans_posx = sans_sprite.global_position.x - 150
	sans_posy = sans_sprite.global_position.y - 120
	
	flowey_posx = flowey_sprite.global_position.x + 70
	flowey_posy = flowey_sprite.global_position.y - 40
	
func _process(delta):
	sans_posx = sans_sprite.global_position.x - 150
	sans_posy = sans_sprite.global_position.y - 120
	
	flowey_posx = flowey_sprite.position.x + 70
	flowey_posy = flowey_sprite.position.y - 40
	
	if Input.is_action_just_pressed("ui_accept") and isCastedFromMain:
		_cast_dialogue()
		
	if text_tween.is_active() and line_index - 1 < dialogue.size():
		var pos = blitter.get_visible_characters()
		
		var getchar = blitter.bbcode_text[blitter.visible_characters]
		if getchar != " " or getchar != "." or getchar != ",":
			if charSpeaker[line_index - 1] == 0: $Sans.play()
			if charSpeaker[line_index - 1] == 1: $Flowey.play()
			$Sans.pitch_scale = rand_range(0.98, 1.02)
			$Flowey.pitch_scale = rand_range(0.98, 1.02)

var tc = 0.0

var isCastedFromMain = true

func _cast_dialogue():
	isCastedFromMain = true
	if line_index < dialogue.size():
		print(1)
		if charSpeaker[line_index] == 1:
			blitter.add_color_override("font_color_shadow", Color(0, 0, 0, 0))
			bubble.flip_h = false
			bubble.position.x = flowey_posx
			bubble.position.y = flowey_posy
			blitter.rect_position.x = flowey_posx - 65
			blitter.rect_position.y = flowey_posy - 55
			
			
			var dynamic_font = DynamicFont.new()
			dynamic_font.font_data = load("res://determination-mono-web-font/DeterminationSansWebRegular-369X.ttf")
			dynamic_font.size = 15
			dynamic_font.extra_spacing_char = 1.8
			blitter.add_font_override("normal_font", dynamic_font)
		
		
		if charSpeaker[line_index] == 0:
			blitter.add_color_override("font_color_shadow", Color(0, 0, 0, 0.1))
			bubble.flip_h = true
			bubble.position.x = sans_posx
			bubble.position.y = sans_posy
			blitter.rect_position.x = sans_posx - 85
			blitter.rect_position.y = sans_posy - 55
			
			var dynamic_font = DynamicFont.new()
			dynamic_font.font_data = load("res://determination-mono-web-font/pixel-comic-sans-undertale-sans-font.ttf")
			dynamic_font.size = 15.6
			
			if line_index == 6 and tc == 13:
				dynamic_font.font_data = load("res://determination-mono-web-font/DeterminationSansWebRegular-369X.ttf")
				dynamic_font.size = 18
				dynamic_font.extra_spacing_char = 1.8
			blitter.add_font_override("normal_font", dynamic_font)
		
		text_tween.remove_all()
		blitter.bbcode_text = dialogue[line_index]
		blitter.percent_visible = 0.0
		text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * char_read, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		text_tween.start()
		
		floweyHeadSpr.frame = floweyHead[line_index]
		sansHeadSpr.frame = sansHead[line_index]
		sanshandspr.frame = sansHand[line_index]
		
	else:
		if tc <= 13: emit_signal("dialogue_finished")
		floweyHeadSpr.frame = 0
		sansHeadSpr.frame = 0
		self.set_process(false)
		
		self.hide()
		
	line_index += 1

func _tempStopTween():
	text_tween.stop_all()
	yield(get_tree().create_timer(0.06, false), "timeout")
	text_tween.resume_all()

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
	tc = turn_count
	line_index = 0
	if turn_count == 0:
		dialogue = []
		charSpeaker = []
		floweyHead = []
		sansHead = []
	if turn_count == 1:
		dialogue = [
			"я не буду утомлять тебя подробностями.", 
			"просто... эм... я здесь не по своей воле.", 
			"я просто сдался некоторое время назад, но, в общем...", 
			"я думаю, что мир всё ещё найдёт мне применение.", 
		]
		charSpeaker = [0, 0, 0, 0]
		floweyHead = [0, 0, 0, 0]
		sansHead = [0, 1, 1, 2]
		sansHand = [0, 0, 1, 0]
	
	if turn_count == 2:
		dialogue = [
			"я бы не занимался всем этим, если бы не был вынужден.", 
			"не усложняй себе жизнь больше, чем это необходи-", 
			"Приветик! Фриск случайно не рассказывал обо мне?", 
			"к сожалению.", 
			"Заткнись, мусорка! Здесь стоит ДУША, которую мы обязаны забрать!", 
		]
		charSpeaker = [0, 0, 1, 0, 1]
		floweyHead = [1, 1, 5, 5, 0]
		sansHead = [2, 2, 3, 1, 1]
		sansHand = [0, 1, 0, 0, 0]
	
	if turn_count == 3:
		dialogue = [
			"Наверняка ты сейчас чувствуешь себя подавленной.", 
			"Твои друзья бросили тебя... одну...", 
			"Что тебя ждёт впереди? Холодная, голодная смерть...", 
			"Но не волнуйся! Твой новый друг, Флауи, здесь, чтобы утешить тебя!", 
			"пулями?", 
			"Верно! Это очень гуманная смерть!"
		]
		charSpeaker = [1, 1, 1, 1, 0, 1]
		floweyHead = [5, 5, 6, 5, 1, 7]
		sansHead = [1, 1, 1, 1, 2, 2]
		sansHand = [0, 0, 0, 0, 0, 0]
	
	if turn_count == 4:
		dialogue = [
			"цветок прав, дитя.", 
			"конечно, не в той части, которая связана с убийством...", 
			"но твои друзья разлучились с тобо-", 
			"И разумеется, благодаря мне!", 
			"Хотя ты не была моей целью, но теперь...", 
			"...пойманная, свежая ДУША будет гораздо лучше ДУШИ, которая находится в упадке."
		]
		charSpeaker = [0, 0, 0, 1, 1, 1]
		floweyHead = [0, 0, 0, 7, 6, 5]
		sansHead = [0, 0, 0, 0, 0, 3]
		sansHand = [1, 1, 1, 0, 0, 0]
	
	if turn_count == 5:
		dialogue = [
			"здесь... есть ещё кто-то поблизости?", 
			"Предыдущий Человек никуда не уходил, болван!", 
			"поясни.", 
			"Хорошо! Я совсем недавно столкнулся с предыдущим упавшим Человеком.", 
			"Он был вместе с Папирусом, тоже что-то искали.", 
			"Или, скорее, кого-то... Думаю, теперь мы знаем, кто это.", 
			"...эм. я-", 
			"...", 
			"неважно."
		]
		charSpeaker = [0, 1, 0, 1, 1, 1, 0, 0, 0]
		floweyHead = [5, 0, 1, 3, 1, 3, 4, 1, 1]
		sansHead = [5, 5, 5, 5, 5, 2, 1, 3, 1]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 6:
		dialogue = [
			"а зачем нам новая ДУША, когда есть старая?", 
			"ДУША предыдущего Человека выглядит бледной, словно она истощена.", 
			"У него такая решимость... словно её никогда и не было.", 
			"В остальном она особо ничем не отличается от других.", 
			"хм. странно.", 
			"как это могло случиться?", 
			"Это уже не имеет значения.", 
			"В конце концов, теперь у нас есть гораздо лучший вариант!", 
			"Однако, КТО-ТО не сильно торопится использовать такой шанс."
		]
		charSpeaker = [0, 1, 1, 1, 0, 0, 1, 1, 1]
		floweyHead = [1, 0, 2, 0, 0, 0, 5, 5, 1]
		sansHead = [1, 0, 0, 0, 1, 0, 0, 0, 5]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 7:
		dialogue = [
			"признаю.", 
			"я совершаю ошибку, если её можно так назвать.", 
			"но ты ведь лучше знаешь, что...", 
			"не каждый использует свою самую сильную атаку в первую очередь.", 
			"просто не торопись, и ты поймёшь о чём я говорю.", 
			"хех. наверняка ты не этого ожидал услышать.", 
			"Я... Хорошо! Понял. Ух..."
		]
		charSpeaker = [0, 0, 0, 0, 0, 0, 1]
		floweyHead = [0, 0, 0, 0, 0, 0, 4]
		sansHead = [3, 3, 1, 1, 0, 1, 1]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 8:
		dialogue = [
			"эй, дитя. у тебя всё меньше шансов на отступление.", 
			"я не шутил, когда говорил, что некоторые вещи лучше оставить в прошлом. понимаешь?", 
			"Да! В последнее время ПОДЗЕМЕЛЬЕ превратилось в рассадник зла и ужаса!", 
			"Невозможно даже поговорить с кем-нибудь!", 
			"сколько времени прошло с момента появления последнего Человека?", 
			"Примерно шесть... семь... восемь лет? Я уже сбился со счета.", 
			"И это при условии того, что время здесь еще течёт!"
		]
		charSpeaker = [0, 0, 1, 1, 0, 1, 1]
		floweyHead = [1, 1, 5, 5, 1, 1, 6]
		sansHead = [0, 0, 0, 0, 2, 1, 1]
		sansHand = [1, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 9:
		dialogue = [
			"С того момента в ПОДЗЕМЕЛИИ царит полный хаос.", 
			"Всё, что ты видела раньше - это ничто по сравнению с тем, что тебя ждёт впереди, Человек!", 
			"Хотя, признаю, наблюдать за этим было очень интересно...", 
			"и при этом... ты сохраняешь актуальность своей цели?", 
			"дальше тебя ждёт только смерть.", 
			"и этой смертью могу стать я, или этот цветок...", 
			"... или любой из тех, кто тебе дорог.", 
			"тот 'инцидент', который произошёл здесь, больше не повторится.", 
			"но то, что от него осталось, останется здесь навсегда - и это тебя остановит."
		]
		charSpeaker = [1, 1, 1, 0, 0, 0, 0, 0, 0]
		floweyHead = [1, 0, 6, 1, 0, 0, 0, 0, 0]
		sansHead = [0, 0, 0, 2, 1, 0, 2, 0, 0]
		sansHand = [0, 0, 0, 1, 0, 0, 0, 0, 0]
	
	if turn_count == 10:
		dialogue = [
			"откуда я это знаю? ну...", 
			"иногда... я слышу ЕГО.", 
			"какое-то странное чувство... как дежавю, я думаю.", 
			"призыв к насилию? или просто звук?", 
			"чёрт его знает.", 
			"У тебя явные проблемы, мусорный мешок.", 
			"говори за себя."
		]
		charSpeaker = [0, 0, 0, 0, 0, 1, 0]
		floweyHead = [1, 1, 1, 1, 1, 0, 1]
		sansHead = [0, 1, 1, 2, 2, 5, 5]
		sansHand = [0, 1, 0, 0, 0, 0, 0]
	
	if turn_count == 11:
		dialogue = [
			"Ты говоришь так, будто за нами стоит какая-то могущественная сила.", 
			"это единственное объяснение моих чувств.", 
			"если бы всё зависело от меня, я бы давно сдался.", 
			"и всё же вот я здесь, преследую какую-то неизвестную цель.", 
			"И эта «сила»... это мусор в виде тебя!", 
			"Ты просто пялишься на Человека!", 
			"тебя что-то не устраивает, маленький цветочек?", 
			"Мгх!..."
		]
		charSpeaker = [1, 0, 0, 0, 1, 1, 0, 1]
		floweyHead = [2, 2, 0, 0, 5, 7, 5, 2]
		sansHead = [0, 1, 1, 0, 5, 5, 5, 5]
		sansHand = [0, 1, 1, 0, 0, 0, 0, 0]
	
	if turn_count == 12:
		dialogue = [
			"ладно, я даю тебе последнее предупреждение, подруга.", 
			"если ты сейчас же не уйдёшь...", 
			"тебе точно не понравится то, что произойдет дальше.", 
			"Поверь моему опыту.", 
			"Ты не доживёшь до момента, чтобы кому-нибудь рассказать об этом.", 
			"если тебе вообще осталось хоть что-то рассказать...", 
			"Чем быстрее мы тебя прикончим, тем лучше будет.", 
			"Этот старый друг знает лучше всех."
		]
		charSpeaker = [0, 0, 0, 1, 1, 0, 1, 1]
		floweyHead = [0, 0, 0, 2, 2, 0, 0, 0]
		sansHead = [0, 0, 1, 0, 0, 1, 0, 0]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 13:
		dialogue = [
			"ну что ж. не говори, что я тебя не предупреждал.", 
			"Не говори, что МЫ тебя не предупреждали.", 
			"что бы ты ни говорил, кусок растения.", 
			"если у тебя еще остался кто-то, о ком ты можешь позаботиться...", 
			"я желаю им всего наилучшего.", 
			"потому что, к сожалению...", 
			"Тебя больше никто не увидит."
		]
		charSpeaker = [0, 1, 0, 0, 0, 0, 0, 0]
		floweyHead = [1, 0, 0, 0, 0, 0, 0]
		sansHead = [1, 0, 1, 5, 1, 1, 0]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	if turn_count == 14:
		dialogue = [
			"erm", 
			"wgat"
		]
		charSpeaker = [0, 0]
		floweyHead = [0, 0]
		sansHead = [0, 0]
		sansHand = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	self.set_process(true)
	self.show()
	line_index = 0
	_cast_dialogue()
	
