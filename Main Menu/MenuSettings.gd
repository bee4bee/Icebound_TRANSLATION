extends Node2D


var selection = 0
onready var sndval = $Sound / volNum
var vol_shown = 100
var vol_hidden = 0
var mult = 1.0
var default = Vector2(700, 480)


onready var borderValue = $Borders / on
onready var borderVariable = 0

var buttons = self.get_children().slice(0, 5)

var tween = Tween.new()



func _ready():
	add_child(tween)
	
	# Инициализация всех текстов на русском
	if PlayerData.borderOn: $Borders / on.bbcode_text = "Вкл"
	else: $Borders / on.bbcode_text = "Выкл"
	
	if not OS.window_borderless: $Resizeable / on.bbcode_text = "Вкл"
	else: $Resizeable / on.bbcode_text = "Выкл"
	
	if PlayerData.addLights: $lights / on.bbcode_text = "Вкл"
	else: $lights / on.bbcode_text = "Выкл"
	
	if PlayerData.addParticles: $particles / on.bbcode_text = "Вкл"
	else: $particles / on.bbcode_text = "Выкл"


func _process(delta):
	
	get_child(selection).modulate = Color(1, 1, 1)
	
	selection += int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	if selection < 0: selection = 6
	if selection > 6: selection = 0
	
	get_child(selection).modulate = Color(1, 1, 0)
	
	

func _input(event):
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		$switch.play()
	
	match selection:
		0: _sound_select()
		1: _fx_select()
		2: _windowBorder()
		3: _windowResize()
		4: _multiplier()
		5: _lightenable()
		6: _particleenable()


func _sound_select():
	if Input.is_action_just_pressed("ui_right"):
		vol_shown += 10
		vol_hidden += 4
		if vol_shown > 100: vol_shown = 100
		if vol_hidden > 0: vol_hidden = 0
		_update_sound()
	
	if Input.is_action_just_pressed("ui_left"):
		vol_shown -= 10
		vol_hidden -= 4
		if vol_shown < 0: vol_shown = 0
		if vol_hidden < - 40: vol_hidden = - 80
		_update_sound()

var fx_volShown = 100.0
var fx_volHidden = 0
onready var sndFxVal = $SoundFX / volNum

func _fx_select():
	if Input.is_action_just_pressed("ui_right"):
		fx_volShown += 10
		fx_volHidden += 4
		if fx_volShown > 100: fx_volShown = 100
		if fx_volHidden > 0: fx_volHidden = 0
		_update_sound()
	
	if Input.is_action_just_pressed("ui_left"):
		fx_volShown -= 10
		fx_volHidden -= 4
		if fx_volShown < 0: fx_volShown = 0
		if fx_volHidden < - 40: fx_volHidden = - 80
		_update_sound()

func _update_sound():
	sndval.bbcode_text = str(vol_shown)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol_hidden)
	sndFxVal.bbcode_text = str(fx_volShown)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), fx_volHidden)

func _windowBorder():
	if Input.is_action_just_pressed("ui_right"):
		$Borders / on.bbcode_text = "Вкл"
		PlayerData.borderOn = true
		
		OS.window_size = Vector2(960, 500) * Vector2(mult, mult)
		default = Vector2(960, 500)
		PlayerData.defaultWindowSize = default * mult
		OS.window_position = OS.get_screen_size() / 2 - OS.window_size / 2
		if not OS.window_fullscreen: Border.find_node("Border").modulate.a = 1.0
		else: Border.find_node("BorderFC_tempfix").show()
	
	if Input.is_action_just_pressed("ui_left"):
		$Borders / on.bbcode_text = "Выкл"
		PlayerData.borderOn = false
		tween.remove_all()
		OS.window_size = Vector2(700, 480) * Vector2(mult, mult)
		default = Vector2(700, 480)
		PlayerData.defaultWindowSize = default * mult
		OS.window_position = OS.get_screen_size() / 2 - OS.window_size / 2
		
		Border.find_node("Border").modulate.a = 0.0
		Border.find_node("BorderFC_tempfix").hide()

func _windowResize():
	if Input.is_action_just_pressed("ui_right"):
		$Resizeable / on.bbcode_text = "Вкл"
		OS.window_borderless = false
	
	if Input.is_action_just_pressed("ui_left"):
		$Resizeable / on.bbcode_text = "Выкл"
		OS.window_borderless = true

func _windowFullscreen():
	if Input.is_action_just_pressed("ui_right"):
		$Fullscreen / on.bbcode_text = "Вкл"
		OS.window_fullscreen = true
	if Input.is_action_just_pressed("ui_left"):
		$Fullscreen / on.bbcode_text = "Выкл"
		OS.window_fullscreen = false

func _multiplier():
	if Input.is_action_just_pressed("ui_right"):
		$Multiplier / on.bbcode_text = "x1.5"
		mult = 1.5
	if Input.is_action_just_pressed("ui_left"):
		$Multiplier / on.bbcode_text = "x1"
		mult = 1.0
	OS.window_size = default * mult
	PlayerData.defaultWindowSize = default * mult
	OS.window_position = OS.get_screen_size() / 2 - OS.window_size / 2

func _lightenable():
	if Input.is_action_just_pressed("ui_right"):
		$lights / on.bbcode_text = "Вкл"
		PlayerData.addLights = true
	if Input.is_action_just_pressed("ui_left"):
		$lights / on.bbcode_text = "Выкл"
		PlayerData.addLights = false

func _particleenable():
	if Input.is_action_just_pressed("ui_right"):
		$particles / on.bbcode_text = "Вкл"
		PlayerData.addParticles = true
	if Input.is_action_just_pressed("ui_left"):
		$particles / on.bbcode_text = "Выкл"
		PlayerData.addParticles = false
