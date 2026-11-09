extends Node

var rotvalue = 0
var rotvalue2 = Vector2.ZERO

var i = 0

onready var tweenbox_size = $BattleBox / Resize
onready var arena = $BattleBox / ArenaContainer / Arena
onready var arena_text_container = $BattleBox / ArenaContainer / TextContainer

onready var soul = $Player_Soul
onready var menu = $Menu

onready var blitter = $BattleBox / ArenaContainer / TextContainer / Text
onready var fight_buttons = $Menu / Fight_Options
onready var act_buttons = $Menu / Act_Options
onready var item_buttons = $Menu / Item_Options
onready var mercy_buttons = $Menu / Mercy_Options

onready var slash = $Fight_Scene / Slash
onready var slash_fx = $Fight_Scene / Slash / slash_music

onready var dmg = $Fight_Scene / Damage_Text
onready var dmgtween = $Fight_Scene / Damage_Text / DmgTween
onready var rotation_tween = $Fight_Scene / Damage_Text / RotationTween

var dmgpos_x = 0.0
var dmgpos_y = 0.0

var timer = 0.0
var timer_max = 50.0
var can_time = false


const attacks = [
	"res://Attacks/Waterfall/Attack0/Attack_0.tscn", 
	"res://Attacks/Waterfall/Attack1/Attack_1.tscn", 
	"res://Attacks/Waterfall/Attack2/Attack_2.tscn", 
	"res://Attacks/Waterfall/Attack3/Attack_3.tscn", 
	"res://Attacks/Waterfall/Attack4/Attack_4.tscn", 
	"res://Attacks/Waterfall/Attack5/Attack_5.tscn", 
	"res://Attacks/Waterfall/Attack6/Attack_6.tscn", 
	"res://Attacks/Waterfall/Attack7/Attack_7.tscn", 
	"res://Attacks/Waterfall/Attack8/Attack_8.tscn", 
	"res://Attacks/Waterfall/Attack9/Attack_9.tscn", 
	"res://Attacks/Waterfall/Attack10/Attack_10.tscn", 
	"res://Attacks/Waterfall/Attack11/Attack_11.tscn", 
	"res://Attacks/Waterfall/Attack12/Attack_12.tscn", 
	"res://Attacks/Waterfall/Attack13/Attack_13.tscn", 
]


func _loading():
	
	for i in 14:
		attacks[i] = load("res://Attacks/Waterfall/Attack" + str(i) + "/Attack_" + str(i) + ".tscn")
		yield(get_tree().create_timer(0.01), "timeout")
	
	
export var turn_counter = 0.0
var attack

signal attack_start
signal players_turn

signal attack_reset
signal game_end(soulpos_x, soulpos_y)
signal enemy_turn_dialogue(turn_count)

onready var menusoul = $Menu / Soul

var endscreen_checkcount = 0

var player_is_attacking = false
var counter = 0.0
var enemy_position = 0
var can_count_until_miss = false
var misscounter = 0


var dialmanager

var can_cast_miss = true
var can_begin_attack = false
var can_cast_attack = false

var sans_sprite
var flowey_sprite

var windowtimer = 0.0

var tweenCam = Tween.new()
var canMoveEnemies = true

func _ready():
	add_child(tweenCam)
	
	$BattleBox._box_retween(580, 140, - 216, 5, 1.0)
	dmg.self_modulate = Color(0.35, 0.35, 0.35, 0)
	dmgpos_y = dmg.rect_position.y
	$Dialogue_Manager.set_process(false)
	$Dialogue_Manager.hide()
	
	$Camera.darken_with_set_values(1, 0, 5.0)
	$Camera._castNameplate("Цветочный перелом", "Против Санса и Флауи\nМузыку сделал: Mugger")
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Battle_Sprites / Sans, "position:x", $Battle_Sprites / Sans.position.x + 20, $Battle_Sprites / Sans.position.x, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Battle_Sprites / Flowey, "position:x", $Battle_Sprites / Flowey.position.x - 45, $Battle_Sprites / Flowey.position.x, 0.8, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	RichPresence._update_activity("Vs. Sans, ft. Flowey", "\"Floral Fracture\" - Waterfall")
	
	_loading()
	_check_for_showing_enemies()
	
	if not PlayerData.addLights:
		$Gradient / Light2D7.energy = 0
		$Gradient / Light2D6.energy = 0
		$Gradient / ColorRect.modulate.a = 0
	if not PlayerData.addParticles:
		$Effects / Dots_low.emitting = false
		$Effects / Rain.amount /= 3
	
	PlayerData.finishedAreas[0] = true
	PlayerData._save_game()
	
func _process(delta):
	
	tweenCam.interpolate_property($Camera.get_child(0), "modulate:a", $Camera.get_child(0).modulate.a, 0.028 * (20 - $Player_Soul.hp), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenCam.start()
	
	if not $Menu.action_text_is_shown: _flavor_text()
	
	_check_for_showing_enemies()
	

func _countmiss():
	yield(get_tree().create_timer(0.15, false), "timeout")
	_cast_miss_button()
	yield(get_tree().create_timer(0.6, false), "timeout")
	_end_cast_miss_button()

func _check_for_showing_enemies():
	if turn_counter == 2 and $Dialogue_Manager.line_index == 3 and canMoveEnemies:
		canMoveEnemies = false
		$Battle_Sprites._flowey_appear()
		$Menu.maxEnemyCount = 1
		$Menu / Act_Options / Second.show()
		$Menu / Fight_Options / Second.show()

func _debug_show():
	if canMoveEnemies:
		canMoveEnemies = false
		$Battle_Sprites._flowey_appear()
		$Menu.maxEnemyCount = 1
		$Menu / Act_Options / Second.show()
		$Menu / Fight_Options / Second.show()

var flavortext = [
	"* Тихий снегопад усиливается", 
	"* Ты чувствуешь дезориентацию.", 
	"* Вьющиеся растения раскинулись по всей местности.", 
	"* Санс начинает засыпать.\n* Флауи будит его ударом лианы.", 
	"* Снежная буря становится сильнее.", 
	"* Что-то не так...", 
	"* Ты чувствуешь, как ноги затекают от сильного холода.", 
	"* Флауи что-то бормочет.\n* Санс в ответ бросает ему \n  кость.", 
	"* Снежная буря не прекращается, ухудшая твоё зрение.", 
	"[color=#ff8dbb]* Что здесь вообще происходит?[/color]", 
	"* Сильный холод заставляет тебя кричать.", 
	"* Несмотря на ситуацию, ты держишься.", 
	"* Сейчас или никогда.", 
	"о нет..."
]

func _flavor_text():
	blitter.bbcode_enabled = true
	blitter.bbcode_text = flavortext[turn_counter]

func _on_Menu_player_is_attacking(enemy_pos, is_attack_active):
	enemy_position = enemy_pos
	player_is_attacking = is_attack_active
	if player_is_attacking == true:
		$Menu.set_process(false)
		fight_buttons.hide()
		$Fight_Scene.set_process(true)
	else: $Fight_Scene.set_process(false)
	
	
func _on_Fight_Scene_attack_is_casted(hit_position):
	
	_countmiss()
	
	if enemy_position == 0:
		slash.global_position = $Battle_Sprites / Sans.global_position - Vector2(0, 60)
		dmgpos_x = slash.global_position.x - 60
		var x = rand_range(0.0, 100.0)
		if x <= 20.0 + (20.0 - soul.hp) * 2: $Battle_Sprites / Sans._shrugdodge()
	if enemy_position == 1:
		slash.global_position = $Battle_Sprites / Flowey.global_position
		dmgpos_x = 330
	
	slash.frame = 0
	slash.rotation = cos(hit_position)
	slash.play()
	slash_fx.play()
	emit_signal("attack_start")
	

func _on_Fight_Scene_enemy_turn_begin(scale_x_finish, pos_x_finish, scale_y_finish, pos_y_finish):
	soul.position = Vector2(320, 310)
	soul.soul_is_active = true
	$BattleBox.can_cast_barriers = true
	$BattleBox._box_retween(200, 150, - 25, 0, 0.6)
	turn_counter += 1
	yield(get_tree().create_timer(0.6, false), "timeout")
	emit_signal("enemy_turn_dialogue", turn_counter)


func _time_counting(delta):
	var d = attacks[turn_counter].instance()
	
	if turn_counter == 13:
		$Music.stop()
		$Music_endSegment.play()
	$BattleBox / ArenaContainer / Arena / Attacks.add_child(d)
		

func _return_to_selection():
	
	soul._red()
	soul.soul_is_active = false
	soul.is_in_bullet = false
	
	$Menu.set_process(true)
	
	emit_signal("players_turn")
	emit_signal("attack_reset")
	
	$BattleBox / ArenaContainer / Arena / Tween.remove_all()
	
	$BattleBox / ArenaContainer / Arena / Attacks.get_child(0).queue_free()
	$BattleBox.can_cast_barriers = false
	
	yield(get_tree().create_timer(0.01, false), "timeout")
	$BattleBox._box_retween(580, 140, - 216, 5, 1.0)
	
	menusoul.position = soul.position
	soul.position = Vector2(0, 0)
	timer = 0.0
	can_time = false
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Battle_Sprites / Flowey, "modulate", $Battle_Sprites / Flowey.modulate, Color(1, 1, 1, 1), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Battle_Sprites / Sans, "modulate", $Battle_Sprites / Sans.modulate, Color(1, 1, 1, 1), 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Camera.darken(0.0, 1.5)
	tween.start()
	_flavor_text()
	yield(get_tree().create_timer(0.2, false), "timeout")
	$BattleBox / ArenaContainer / Arena.rect_rotation = 0.0
	
func _cast_miss_button():
	dmg.self_modulate = Color(0.8, 0.8, 0.8, 1)
	dmg.rect_rotation = 0
	
	dmg.text = "МИМО"
	dmg.rect_position = Vector2(dmgpos_x, dmgpos_y)
	
	dmgtween.remove_all()
	dmgtween.interpolate_property(dmg, "rect_position:y", dmg.rect_position.y, 42, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	dmgtween.interpolate_property(dmg, "self_modulate", dmg.self_modulate, Color(0.8, 0.8, 0.8, 1), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	dmgtween.start()
	
	rotation_tween.interpolate_property(dmg, "rect_rotation", dmg.rect_rotation, rand_range( - 30, 30), 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	rotation_tween.start()
	
	
func _end_cast_miss_button():
	dmgtween.remove_all()
	dmgtween.interpolate_property(dmg, "self_modulate", dmg.self_modulate, Color(0.8, 0.8, 0.8, 0), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	dmgtween.start()


func _on_Dialogue_Manager_dialogue_finished():
	_time_counting(get_process_delta_time())

func _endFrame():
	var frame = $death
	var tw = Tween.new()
	add_child(tw)
	frame.show()
	$Gradient / ColorRect.hide()
	$Camera.flash(6.0)
	tw.interpolate_property(frame, "modulate", frame.modulate, Color(1, 1, 1, 1), 0.4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Camera / Glitch.show()
	tw.interpolate_property($Camera / Glitch.material, "shader_param/speed", 0.0, 1.0, 0.1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.interpolate_property($Camera / Glitch.material, "shader_param/amt", 0.6, 0.0, 5.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
	yield(get_tree().create_timer(2.5, false), "timeout")
	tw.interpolate_property(frame, "modulate", frame.modulate, Color(0, 0, 0, 1), 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	
	yield(get_tree().create_timer(4, false), "timeout")
	tw.interpolate_property($Music_endSegment, "volume_db", 0, - 80, 8.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
