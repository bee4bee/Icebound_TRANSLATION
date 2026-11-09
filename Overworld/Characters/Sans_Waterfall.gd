extends StaticBody2D


export var lineIndex = 12.0
export var blitter = [
	"...", 
	"...?", 
	"...оу.", 
	"...ты...", 
	"(...он, или кто-то другой.)", 
	"...хм.", 
	"полагаю, мне нужно представиться.", 
	"я санс. скелет санс.", 
	"а ты...?", 
	"...", 
	"... думаю, это неважно.", 
	"ладно. сегодня неплохой денёк.", 
	"может, прогуляемся и поболтаем?"
]

export var expr = ["s", "s", "s", "s", "s", "s", "s", "s", "s", "ch", "s", "s", "s"]
export var exprFrame = [2, 1, 0, 0, 1, 1, 0, 1, 1, 2, 1, 2, 0]

func _ready():
	if PlayerData.WaterfallDeath:
		blitter = ["..."]
		lineIndex = 0.0





