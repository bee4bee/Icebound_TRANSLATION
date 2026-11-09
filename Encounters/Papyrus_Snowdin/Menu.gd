extends Node2D

onready var fight = $Fight
onready var act = $Act
onready var item = $Item
onready var mercy = $Mercy

var enable = false
export var action_text_is_shown = false
export var act_enable = false

export var fight_section_selected = false
export var act_section_selected = false
export var item_section_selected = false
export var mercy_section_selected = false

export var attack_target = 0

var selection = 0
var pos = 0
var ok = 0
var z_count = 0
var pos_selection = 0
var selection_list = []
var act_pos_count = 0
var fight_pos_count = 0
var testvar = 0

onready var soul = $Soul
var positionArray = [60, 170, 470, 580]
var posArray_top = [65, 313]

onready var button = get_children().slice(0, 3)
onready var resize_tween = $Resize
onready var soultween = $MoveSoul

onready var fight_button = $Fight_Options.get_children().slice(0, 1)
onready var act_button = $Act_Options.get_children().slice(0, 1)
onready var item_button
onready var mercy_button = $Mercy_Options.get_children().slice(0, 1)

onready var blitter = get_node("/root/Battle_Engine/BattleBox/ArenaContainer/TextContainer/Text")
onready var box = get_node("/root/Battle_Engine/BattleBox")
signal blitter_visibility(blitter_is_visible)
signal different_blitter(new_blitter)
signal player_is_attacking(enemy_position, is_attack_active)
signal select


func _ready():
	$Fight_Options / First.bbcode_text = "* Папирус"
	
	item_button = $Item_Options / Row_1.get_children().slice(0, 1)
	item_button.append_array($Item_Options / Row_2.get_children().slice(0, 1))
	
	item_button[0].bbcode_text = "* Цвет. венок"
	item_button[1].bbcode_text = "* Кусок снега"
	item_button[2].bbcode_text = "* Пирог"
	item_button[3].bbcode_text = "* --"
	$Item_Options.hide()

func _process(delta):
	
	emit_signal("player_is_attacking", - 1, false)
	button[pos].frame = 0
	
	_start_options()
	
	if act_enable == false:
		$Fight_Options.hide()
		$Act_Options.hide()
		$Item_Options.hide()
		$Mercy_Options.hide()
		
		if Input.is_action_just_pressed("ui_left"): pos -= 1
		if Input.is_action_just_pressed("ui_right"): pos += 1
		if (pos > 3): pos = 0
		if (pos < 0): pos = 3
		button[pos].frame = 1
			
		soultween.interpolate_property(soul, "position:x", soul.position.x, positionArray[pos], 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
		soultween.interpolate_property(soul, "position:y", soul.position.y, button[pos].position.y - 6, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
		
	match pos:
		0: _fight_options()
		1: _act_options()
		2: _item_options()
		3: _mercy_options()
	
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		$Option_Movement.play()
		
	soultween.start()

	_blitter_check()
		
func _start_options():
	if Input.is_action_just_pressed("ui_accept") and act_enable == false:
		$Option_Select.play()
		act_enable = true
		pos_selection = 0

func _blitter_check():
	if act_enable == true:
		blitter.hide()
		box._cancel_text()
	else: blitter.show()

func _fight_options():
	if act_enable == true:
		
		fight_section_selected = true
		action_text_is_shown = false
		$Fight_Options.show()
		
		fight_button[0].bbcode_text = "* Папирус"
		
		pos_selection = 0
		
		_interpolate_soul_position_top()
		
		if Input.is_action_just_pressed("ui_accept") and fight_pos_count == 1:
			emit_signal("player_is_attacking", pos_selection, true)
			$Soul.hide()
			act_enable = false
			fight_section_selected = false
			fight_pos_count = 0
			self.set_process(false)
		
		if Input.is_action_just_pressed("ui_cancel"):
			$Option_Movement.play()
			pos_selection = 0
			act_enable = false
			fight_pos_count = 0
			fight_section_selected = false
		
		if Input.is_action_just_pressed("ui_accept"):
			fight_pos_count += 1

func _act_options():
	if act_enable == true:
		
		act_section_selected = true
		
		action_text_is_shown = false
		$Act_Options.show()
		
		pos_selection = 0
		
		_interpolate_soul_position_top()
		
		if Input.is_action_just_pressed("ui_accept"):
			$Option_Select.play()
			act_pos_count += 1
			selection_list.append(pos_selection)
			
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
			pos_selection = 0
			act_button[0].bbcode_text = " "
			act_button[1].bbcode_text = " "
			
		if Input.is_action_just_pressed("ui_cancel"):
			$Option_Movement.play()
			selection_list.pop_back()
			act_pos_count -= 1
		
		match act_pos_count:
			1:
				act_button[0].bbcode_text = "* Папирус"
			2:
				act_button[0].bbcode_text = "* Проверить"
				if pos_selection > 0:
					pos_selection = 0
			3:
				if selection_list[1] == 0: box._create_text("* Папирус - 20 АТК 20 ЗАЩ\n* Он любит говорить 'НЬЕХ-ХЕХ-ХЕ!'.\n  Бывает, что очень много...")
				blitter.show()
				action_text_is_shown = true
				act_pos_count = 0
				act_enable = false
				selection_list.clear()
			
		if act_pos_count == 0:
			act_enable = false
			act_section_selected = false
			

var itemCanUse = [3, 2, 1, 0]
var item_pos_count = 0
onready var pSoul = get_node("/root/Battle_Engine/Player_Soul")

func _item_options():
	if act_enable == true:
		
		item_section_selected = true
		
		action_text_is_shown = false
		$Item_Options.show()
		
		if Input.is_action_just_pressed("ui_accept") and item_pos_count == 1:
			item_pos_count = 0
			if pos_selection == 0 and itemCanUse[pos_selection] > 0:
				
				itemCanUse[pos_selection] -= 1
				if itemCanUse[pos_selection] == 0: item_button[0].bbcode_text = "* --"
				pSoul.hp += 10
				$Heal.play()
				if pSoul.hp > 20: pSoul.hp = 20
				if itemCanUse[pos_selection] == 2: box._create_text("* Ты использовала цвет. венок.\n* Ты восстановила 10 ОЗ!\n* Осталось 2 использования.")
				if itemCanUse[pos_selection] == 1: box._create_text("* Ты использовала цвет. венок.\n* Ты восстановила 10 ОЗ!\n* Осталось 1 использование.")
				if itemCanUse[pos_selection] == 0: box._create_text("* Ты использовала цвет. венок.\n* Ты восстановила 10 ОЗ!")
				_remove_options_and_go_to_box()
			
			if pos_selection == 1 and itemCanUse[pos_selection] > 0:
				
				itemCanUse[pos_selection] -= 1
				if itemCanUse[pos_selection] == 0: item_button[1].bbcode_text = "* --"
				pSoul.hp += 15
				$Heal.play()
				if pSoul.hp > 20: pSoul.hp = 20
				if itemCanUse[pos_selection] == 1: box._create_text("* Это снег. Он сладкий на вкус.\n* Твоё здоровье востановленно!\n* Осталось 1 использование.")
				if itemCanUse[pos_selection] == 0: box._create_text("* Это снег. Он сладкий на вкус.\n* Твоё здоровье востановленно!")
				_remove_options_and_go_to_box()
			if pos_selection == 2 and itemCanUse[pos_selection] > 0:
				item_button[2].bbcode_text = "* --"
				itemCanUse[pos_selection] -= 1
				pSoul.hp += 20
				$Heal.play()
				if pSoul.hp > 20: pSoul.hp = 20
				box._create_text(
					"* Вкус... он напоминает тебе о давно ушедшей эпохе.\n* Твоё здоровье востановленно!"
				)
				_remove_options_and_go_to_box()
		item_pos_count = 1
		
		if Input.is_action_just_pressed("ui_accept") and item_pos_count == 1: item_pos_count = 0
		
		if Input.is_action_just_pressed("ui_left"): pos_selection -= 1
		if Input.is_action_just_pressed("ui_right"): pos_selection += 1
		if Input.is_action_just_pressed("ui_up"): pos_selection -= 2
		if Input.is_action_just_pressed("ui_down"): pos_selection += 2
		if (pos_selection > 3): pos_selection = 0
		if (pos_selection < 0): pos_selection = 3
		
		match pos_selection:
			0, 1:
				_interpolate_soul_position_top()
			2, 3:
				_interpolate_soul_position_bottom()
				
		if Input.is_action_just_pressed("ui_cancel"):
			$Option_Movement.play()
			$Item_Options.hide()
			pos_selection = 0
			act_enable = false
			item_pos_count = 0
			
			item_section_selected = false

func _mercy_options():
	if act_enable == true:
		
		mercy_section_selected = true
		action_text_is_shown = false
		$Mercy_Options.show()
		
		mercy_button[1].bbcode_enabled = true
		mercy_button[0].bbcode_text = "* Пощада"
		
		mercy_button[1].self_modulate = Color(86, 90, 93, 255)
		
		if Input.is_action_just_pressed("ui_left"): pos_selection -= 1
		if Input.is_action_just_pressed("ui_right"): pos_selection += 1
		if (pos_selection > 0): pos_selection = 0
		if (pos_selection < 0): pos_selection = 0
		
		
		_interpolate_soul_position_top()
		
		if Input.is_action_just_pressed("ui_cancel"):
			$Option_Movement.play()
			$Mercy_Options.hide()
			pos_selection = 0
			item_pos_count = 0
			act_enable = false
			
			mercy_section_selected = false

func _interpolate_soul_position_top():
	soultween.interpolate_property(soul, "position:x", soul.position.x, posArray_top[pos_selection], 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	soultween.interpolate_property(soul, "position:y", soul.position.y, 270, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
func _interpolate_soul_position_bottom():
	soultween.interpolate_property(soul, "position:x", soul.position.x, posArray_top[pos_selection - 2], 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	soultween.interpolate_property(soul, "position:y", soul.position.y, 313, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)


func _remove_options_and_go_to_box():
	blitter.show()
	action_text_is_shown = true
	act_pos_count = 0
	act_enable = false
	selection_list.clear()

func _on_Battle_Engine_attack_reset():
	fight_pos_count = 0
	soul.show()
