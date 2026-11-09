extends StaticBody2D


export var lineIndex = 1.0
export var blitter = [
	"Эхо-цветок, покрытый льдом.", 
	"Он шепчет нежную колыбельную...", 
]

export var expr = ["ch", "ch"]
export var exprFrame = [0, 0]




func _ready():
	if not PlayerData.addLights:
		$Light2D8.queue_free()





