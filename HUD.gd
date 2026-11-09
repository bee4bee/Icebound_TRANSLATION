extends Control


onready var hpbar = $TextureProgress
onready var hp = $CurrentHP

onready var stamina = $Stamina / bar

var tw = Tween.new()

func _ready():
	add_child(tw)


func _on_Player_Soul_current_hp(hp_amount):
	hpbar.value = hp_amount
	
	
	hp.bbcode_text = str(hp_amount)

func _update_owPlayer_hp(hitpoints):
	hpbar.value = hitpoints
	hp.bbcode_text = str(hitpoints)

func _change_stamina(stam):
	tw.interpolate_property(stamina, "value", stamina.value, stam, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tw.start()
