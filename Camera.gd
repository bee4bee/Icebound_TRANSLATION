extends Camera2D

onready var tween = $Tween


func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func _resize_camera(posX, posY, zoomX, zoomY, duration):
	
	tween.interpolate_property(self, "position", position, Vector2(posX, posY), duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "zoom", zoom, Vector2(zoomX, zoomY), duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	
	tween.start()

func _resize_cam_out(pos, zom, duration):
	
	tween.interpolate_property(self, "position", position, pos, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(self, "zoom", zoom, zom, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	tween.start()
	
func _rotate_camera(rot, duration):
	tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rot, duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()

export var decay = 0.8
export var max_offset = Vector2(100, 50)
export var max_roll = 0.1
export (NodePath) var target

var trauma = 0.0
var trauma_power = 2
onready var noise = OpenSimplexNoise.new()
var noise_y = 0


func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
	
	
	
	
	
func add_trauma(amount):
	trauma = amount
	
func flash(duration):
	$ColorRect.modulate = Color(1, 1, 1, 0)
	$Tween.interpolate_property($ColorRect, "modulate:a", 1.0, 0.0, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func _flash_dark(duration):
	$ColorRect.modulate = Color(0, 0, 0, 1.0)
	var musicVolume = AudioServer.get_bus_volume_db(2)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), - 80.0)
	$flash.play()
	yield(get_tree().create_timer(duration, false), "timeout")
	$flash.play()
	$ColorRect.modulate = Color(0, 0, 0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume)
	
func _whiten_with_set_values(start, end, duration):
	$ColorRect.modulate = Color(1, 1, 1, start)
	$Tween.interpolate_property($ColorRect, "modulate:a", start, end, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func darken(amount, duration):
	$ColorRect.modulate = Color(0, 0, 0, 0)
	$Tween.interpolate_property($ColorRect, "modulate:a", 0.0, amount, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func darken_with_set_values(start, end, duration):
	$ColorRect.modulate = Color(0, 0, 0, start)
	$Tween.interpolate_property($ColorRect, "modulate:a", start, end, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _blur(start, end, time, deblur: bool = true):
	$Blur.show()
	$Tween.interpolate_property($Blur.material, "shader_param/lod", start, end, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if deblur:
		yield(get_tree().create_timer(time / 2, false), "timeout")
		$Tween.interpolate_property($Blur, "modulate:a", 1.0, 0.0, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.start()

func _glitch(amt1, amt2, time):
	$Glitch.show()
	tween.interpolate_property($Glitch.material, "shader_param/amt", amt1, 0.0, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Glitch.material, "shader_param/speed", amt2, 0.0, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Glitch, "modulate:a", 1.0, 0.0, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(time, false), "timeout")
	$Glitch.hide()

func _cam_beat(amount):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "zoom", self.zoom - Vector2(amount, amount), self.zoom, 2.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

onready var nameplate = $AreaNameplate
func _castNameplate(title, credits):
	nameplate._castNameplate(title, credits)

func _remove_tweens():
	$Tween.remove_all()
