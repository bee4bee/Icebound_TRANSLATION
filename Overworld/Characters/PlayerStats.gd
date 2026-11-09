extends CanvasLayer

onready var menu = $Control
onready var select = $Control / Select
onready var details = $Control / Details

var selection = 0.0
var tween = Tween.new()

export var isActive = false



func _ready():
	add_child(tween)
	menu.modulate.a = 0.0
	

func _process(delta):
	$Control / Details / Items / Item1.text = PlayerData.items[0]
	$Control / Details / Items / Item2.text = PlayerData.items[1]
	$Control / Details / Items / Item3.text = PlayerData.items[2]
	$Control / Details / Items / Item4.text = PlayerData.items[3]
	if Input.is_action_just_pressed("menu_appear") and get_parent().canMove and not PlayerData.isPaused:
		_showMenu()
		isActive = true
		PlayerData.isInMenu = true
		get_tree().paused = true
	if Input.is_action_just_pressed("ui_cancel") and details.is_visible_in_tree() and not PlayerData.isPaused:
		_hideMenu()
		isActive = false
		PlayerData.isInMenu = false
		get_tree().paused = false
		
	
	if isActive:
		_options()


func _showMenu():
	tween.interpolate_property(menu, "modulate:a", menu.modulate.a, 1.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	var x = 0.0
	if PlayerData.borderOn == true: x = 70.0
	tween.interpolate_property(menu, "rect_position:x", menu.rect_position.x, 20 + x, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _hideMenu():
	var x = 0.0
	if PlayerData.borderOn == false: x = 70.0
	tween.interpolate_property(menu, "modulate:a", menu.modulate.a, 0.0, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(menu, "rect_position:x", menu.rect_position.x, 0 + x, 0.6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func _options():
	
	select.get_child(selection).modulate = Color(1, 1, 1)
	details.get_child(selection).hide()
	if Input.is_action_just_pressed("ui_down"): selection += 1
	if Input.is_action_just_pressed("ui_up"): selection -= 1
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"): $Select.play()
	if selection > 1: selection = 0
	if selection < 0: selection = 1
	
	select.get_child(selection).modulate = Color(0.95, 1, 0)
	details.get_child(selection).show()
