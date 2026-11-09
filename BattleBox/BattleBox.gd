extends Control

onready var resize_tween = $Resize
onready var position_tween = $Positioning
onready var text_tween = $TextTween





onready var arena_textborder = $ArenaContainer
onready var arena = $ArenaContainer / Arena
onready var textcont = $ArenaContainer / TextContainer

onready var b_right = $ArenaContainer / Arena / Collisions / barrier_right
onready var b_left = $ArenaContainer / Arena / Collisions / barrier_left
onready var b_top = $ArenaContainer / Arena / Collisions / barrier_top
onready var b_bottom = $ArenaContainer / Arena / Collisions / barrier_bottom

onready var blitter = $ArenaContainer / TextContainer / Text

onready var square = $ArenaContainer / Arena / ColorRect

onready var menu = get_parent().find_node("Menu")
export var blitter_is_active = true
export var blitter_is_shown_mainnode_act = true
export var can_cast_barriers = false


export var pos_x = 0.0
export var pos_y = 0.0


var char_read = 0.04
var text = "j"
var i = 0

var node = Node2D.new()

func _ready():
	add_child(node)
	node.position.x -= 180
	
	
	
func _process(delta):
	
	arena.rect_pivot_offset = arena.rect_size / 2
	
	textcont.rect_position.x = arena.rect_position.x - 5
	textcont.rect_size.x = arena.rect_size.x - 5
	if i < 0:
		blitter.bbcode_text = " "
		text_tween.remove_all()
		i = i
	else: i += 1
	if i == 1:
		_box_tween_create_text()
		_box_barrier_scale()
	
	b_bottom.position.y = $ArenaContainer / Arena.rect_size.y + 200
	b_top.position.y = $ArenaContainer / Arena / Collisions / barrier_bottom.position.y - $ArenaContainer / Arena.rect_size.y - 398
	b_right.position.x = $ArenaContainer / Arena.rect_size.x + 198
	b_left.position.x = $ArenaContainer / Arena / Collisions / barrier_right.position.x - $ArenaContainer / Arena.rect_size.x - 396
	
	if text_tween.is_active():
		var pos = blitter.get_visible_characters()
		
		var getchar = blitter.text[blitter.visible_characters]
		if getchar != " " or getchar != "." or getchar != ",":
			$Blitter_Sound.play()
			$Blitter_Sound.pitch_scale = rand_range(0.98, 1.02)

func _box_barrier_scale():
	
	b_bottom.scale.x = arena.rect_size.x
	b_bottom.scale.y = 1
	b_top.scale.x = arena.rect_size.x
	b_top.scale.y = 1
	b_left.scale.y = arena.rect_size.y
	b_left.scale.x = 1
	b_right.scale.y = arena.rect_size.y
	b_right.scale.x = 1

func _create_text(text):
	blitter.percent_visible = 0.0
	blitter.bbcode_text = text
	text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * char_read, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	text_tween.start()

func _cancel_text():
	text_tween.remove_all()
	blitter.percent_visible = 1.0

func _on_Menu_player_is_attacking(enemy_position, is_attack_active):
	if is_attack_active == true:
		i = - 10

func _box_tween_create_text():
	blitter.percent_visible = 0.0
	text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * char_read, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_tween.start()

func _on_Battle_Engine_players_turn():
	text_tween.remove_all()
	i = 0
	
func _box_retween(scale_x_final, scale_y_final, pos_x_final, pos_y_final, duration):
	arena = $ArenaContainer / Arena
	var resTween = Tween.new()
	add_child(resTween)
	
	resTween.interpolate_property(arena, "rect_size", arena.rect_size, Vector2(scale_x_final, scale_y_final), duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	resTween.interpolate_property(arena, "rect_position", arena.rect_position, Vector2(pos_x_final, pos_y_final), duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	
	resTween.start()

func _box_resize(scale, pos, time, transtype: String = ""):
	arena = $ArenaContainer / Arena
	var tw = Tween.new()
	add_child(tw)
	if transtype == "":
		tw.interpolate_property(arena, "rect_size", arena.rect_size, scale, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tw.interpolate_property(arena, "rect_position", arena.rect_position, arena.rect_position + pos, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	else:
		tw.interpolate_property(arena, "rect_size", arena.rect_size, scale, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tw.interpolate_property(arena, "rect_position", arena.rect_position, arena.rect_position + pos, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	
func _box_resize_linear(size, pos, duration):
	arena = $ArenaContainer / Arena
	var resTween = $ArenaContainer / Arena / Tween
	
	resTween.interpolate_property(arena, "rect_size", arena.rect_size, size, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	resTween.interpolate_property(arena, "rect_position", arena.rect_position, pos, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	resTween.start()
	
func _box_rotate(rotationValue, duration):
	arena = $ArenaContainer / Arena
	var resTween = $ArenaContainer / Arena / Tween
	
	resTween.interpolate_property(arena, "rect_rotation", rect_rotation, rect_rotation + rotationValue, duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	resTween.start()

func _box_rotate_direct(rotationValue, duration):
	arena = $ArenaContainer / Arena
	var resTween = $ArenaContainer / Arena / Tween
	
	resTween.interpolate_property(arena, "rect_rotation", rect_rotation, rect_rotation + rotationValue, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	resTween.start()

func _something_rotation_reset():
	$ArenaContainer / Arena.rect_rotation = 0.0


func _box_flash(duration):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(square, "color:a", 1.0, 0.0, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

export var canBreakText = true

func _floweyCheckSequence():
	_create_text("* ФЛАУИ - ")
	menu.canAct = false
	yield(get_tree().create_timer(0.5, false), "timeout")
	text = $ArenaContainer / TextContainer / Text
	for i in text.get_total_character_count():
		var label = text.duplicate()
		node.add_child(label)
		label.text = text.bbcode_text[i]
		label.rect_position.x = 0 + i * text.get_font("normal_font").size / 2
	_break()
	_create_floweys_text("* [shake rate=30 level=6]Твой ЛУЧШИЙ друг![/shake]")
	menu.canAct = true
	canBreakText = false

func _create_floweys_text(text):
	blitter.percent_visible = 0.0
	blitter.bbcode_text = text
	text_tween.interpolate_property(blitter, "percent_visible", 0.0, 1.0, len(blitter.bbcode_text) * 0.02, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_tween.start()

onready var camera = get_node("/root/Battle_Engine/Camera")

func _break():
	$FloweyHit.play()
	camera.add_trauma(0.6)
	var tween = Tween.new()
	var bullet = preload("res://Bullets/GigaVine/GigaVine.tscn")
	var b = bullet.instance()
	get_parent().add_child(b)
	b._cast(Vector2( - 80, 270), Vector2(200, 270), Vector2(1.2, 1.2), 0.8, 0.6)
	add_child(tween)
	for i in node.get_children():
		tween.interpolate_property(i, "rect_rotation", 0.0, rand_range( - 100, 100), rand_range(0.4, 1.2), Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	
	var arrayx = []
	arrayx.resize(node.get_child_count())
	var arrayy = []
	arrayy.resize(node.get_child_count())
	
	var fl = get_parent().find_node("Battle_Sprites").get_child(1).get_child(1)
	fl.frame = 7
	for i in node.get_child_count():
		arrayx[i] = int(rand_range( - 280.0, 280.0)) * 0.025
		arrayy[i] = rand_range( - 170.0, - 160.0) * 0.025
	for i in 480:
		for j in node.get_children():
			j.rect_position += Vector2(arrayx[j.get_index()], arrayy[j.get_index()])
		for k in node.get_child_count():
			if arrayx[k] < 0: arrayx[k] += 0.02 * 0.025
			if arrayx[k] > 0: arrayx[k] -= 0.02 * 0.025
			arrayy[k] += 10.0 * 0.025
		yield(get_tree().create_timer(0.013, false), "timeout")
	for i in node.get_children():
		node.remove_child(i)
