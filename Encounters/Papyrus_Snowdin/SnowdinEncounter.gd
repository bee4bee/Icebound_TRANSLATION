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

var attackP = "res://Attacks/Papyrus_Attack/Papyrus_Attack.tscn"

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

var turn_counter = 0.0
var dialmanager

var can_cast_miss = true
var can_begin_attack = false
var can_cast_attack = false

var sans_sprite
var flowey_sprite

var windowtimer = 0.0

var tweenCam = Tween.new()
var tween = Tween.new()

func _ready():
	OS.set("rendering/2d/snapping/use_gpu_pixel_snap", false)
	add_child(tweenCam)
	add_child(tween)
	
	$MovingWallStuff.set_process(false)
	$MovingWallStuff.hide()
	RichPresence._update_activity("Vs. Papyrus", "\"Blossoming Bravery\" - Cherryside")
	$Player_Soul.immunity_time = 7.0
	$Player_Soul.damage = 3.0
	
	$BattleBox._box_retween(580, 140, - 216, 5, 1.0)
	dmg.self_modulate = Color(0.35, 0.35, 0.35, 0)
	dmgpos_y = dmg.rect_position.y
	$Dialogue_Manager.set_process(false)
	$Dialogue_Manager.hide()
	
	$Camera.darken_with_set_values(1.0, 0.0, 2.0)
	$Camera._castNameplate("Цветущая храбрость", "Против Папируса\nМузыку сделал: Mugger")
	$Camera._blur(1.4, 0.0, 3.5)
	$papyrus._show_idle()
	
	if not PlayerData.addParticles:
		$Particles2D.amount /= 3
		$Blossom.amount /= 3
	
func _process(delta):
	
	if $Player_Soul.hp > 10: $Player_Soul.damage = 3.0
	if $Player_Soul.hp <= 10:
		$Player_Soul.damage = 2.0
		if $Player_Soul.hp <= 2.0:
			$Player_Soul.damage = 1.0
	
	tweenCam.interpolate_property($Camera.get_child(0), "modulate:a", $Camera.get_child(0).modulate.a, 0.02 * (20 - $Player_Soul.hp), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenCam.start()
	
	if not $Menu.action_text_is_shown: blitter.bbcode_text = "* Папирус бросает тебе вызов!"

func _countmiss():
	yield(get_tree().create_timer(0.15, false), "timeout")
	_cast_miss_button()
	yield(get_tree().create_timer(0.6, false), "timeout")
	_end_cast_miss_button()

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
	
	slash.position = Vector2(150, 150)
	dmgpos_x = 100
	$papyrus / Idle / Head.frame = 4
	tween.interpolate_property($papyrus, "position:x", $papyrus.position.x, $papyrus.position.x + 40, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	slash.show()
	slash.frame = 0
	slash.rotation = cos(hit_position)
	slash.play()
	slash_fx.play()
	
	emit_signal("attack_start")
	yield(get_tree().create_timer(0.6), "timeout")
	tween.interpolate_property($papyrus, "position:x", $papyrus.position.x, $papyrus.position.x - 40, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.start()

func _on_Fight_Scene_enemy_turn_begin(scale_x_finish, pos_x_finish, scale_y_finish, pos_y_finish):
	soul.position.x = 320
	soul.position.y = 310
	soul.soul_is_active = true
	$BattleBox.can_cast_barriers = true
	$BattleBox._box_retween(200, 150, - 25, 0, 1.0)
	turn_counter += 1
	yield(get_tree().create_timer(0.6), "timeout")
	emit_signal("enemy_turn_dialogue", turn_counter)


func _time_counting(delta):
	if turn_counter == 1:
		attack = load(attackP).instance()
	
	$BattleBox / ArenaContainer / Arena / Tween.remove_all()
	$BattleBox / ArenaContainer / Arena / Attacks.add_child(attack)
	$music.play()
	SnowdinMusicSingleton._stop_music()
		

func _return_to_selection():
	soul.soul_is_active = false
	$BattleBox / ArenaContainer / Arena / Attacks.get_child(0).queue_free()
	$BattleBox.can_cast_barriers = false
	$Menu.set_process(true)
	
	emit_signal("players_turn")
	$BattleBox / ArenaContainer / Arena / Tween.remove_all()
	$BattleBox._box_retween(580, 140, - 216, 5, 1.0)
	$BattleBox.rect_rotation = 0.0
	$BattleBox / ArenaContainer / Arena.rect_rotation = 0.0
	print($BattleBox.rect_rotation)
	emit_signal("attack_reset")
	menusoul.position = soul.position
	
	soul.position = Vector2(0, 0)
	timer = 0.0
	
	can_time = false
	
func _cast_miss_button():
	dmg.self_modulate = Color(0.8, 0.8, 0.8, 1)
	dmg.rect_rotation = 0
	
	dmg.text = "МИМО"
	dmg.rect_position = Vector2(dmgpos_x, dmgpos_y)
	
	dmgtween.remove_all()
	dmgtween.interpolate_property(dmg, "rect_position:y", dmg.rect_position.y, 42, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	rotation_tween.interpolate_property(dmg, "rect_rotation", dmg.rect_rotation, 25, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	dmgtween.interpolate_property(dmg, "self_modulate", dmg.self_modulate, Color(0.8, 0.8, 0.8, 1), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	rotation_tween.start()
	dmgtween.start()
	
func _end_cast_miss_button():
	dmgtween.remove_all()
	dmgtween.interpolate_property(dmg, "self_modulate", dmg.self_modulate, Color(0.8, 0.8, 0.8, 0), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	dmgtween.start()


func _on_Dialogue_Manager_dialogue_finished():
	_time_counting(1)

