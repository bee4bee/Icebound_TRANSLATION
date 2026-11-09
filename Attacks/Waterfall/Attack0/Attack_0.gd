extends Node2D

onready var main = get_node("/root/Battle_Engine")
onready var camera = get_node("/root/Battle_Engine/Camera")

var bone_preload = preload("res://Bullets/Bone/Bone.tscn")
var bone
var bonesize

var pellet_preload = preload("res://Bullets/Pellet/Pellet.tscn")
var pellet

var blaster_preload = preload("res://Bullets/Blaster/Blaster.tscn")
var blaster

var sideDet = 0.0

var soul_preload = preload("res://Player_Soul.tscn")
var soul

var box_preload = preload("res://BattleBox.tscn")
var box
var box_size_main
var box_size_arena
var box_timecounter

var sprite_preload = preload("res://Encounters/SpriteAnims/Waterfall/Battle_Sprites.tscn")
var sans_sprite
var flowey_sprite


onready var timer = $Timer

var indexGlobal = 0.0
var index_1 = 0.0
var index_2 = 0.0
var index_3 = 0.0
var index_4 = 0.0

var index_pellet_1 = 0.0

var index_blaster_1 = 0.0

var color_det = 0

var deltavar = 0.0
var i = 0
var k

var bullet_collision

var intbox = 0

func _ready():
	timer.start()
	sans_sprite = sprite_preload.instance().get_child(0)
	flowey_sprite = sprite_preload.instance().get_child(1)
	
	soul = soul_preload.instance()


func _process(delta):
	
	_count_index(delta)
	
	box = box_preload.instance()
	
	box_size_arena = self.get_parent().get_parent()
	box_size_main = box
	box_timecounter = box.get_child(1)
	box_timecounter.show()
	
	if int(indexGlobal) == 1 and indexGlobal >= 1.0:
		print(1)
		get_node("/root/Battle_Engine/BattleBox")._box_retween(300, - 75, 150, 0, 1.0)
		camera._resize_camera(320, 280, 0.7, 0.7, 3.5)
	
	if int(indexGlobal) % 120 == 0:
		
		
		
		blaster = blaster_preload.instance()
		get_node("/root/Battle_Engine").add_child(blaster)
		var soulpos = get_node("/root/Battle_Engine/Player_Soul")
		blaster._cast_blaster(soulpos.position.x, - 10, soulpos.position.x, 100, 30.0, 0.0, 2.5, 1.5)
		
	if indexGlobal >= 475.0:
		camera._resize_camera(320, 240, 1.0, 1.0, 0.0, 2.0)
		main._return_to_selection()
	
	if index_1 >= 3.6:
		index_1 = 0.0
		bone = bone_preload.instance()
		$Bones_1.add_child(bone)
		bone._resize_bullet(
			- 8, 10, 
			- 4, 15, 
			0.0, 
			3, "right", box_size_arena.rect_size.x
		)
		
	if index_2 >= 3.6:
		index_2 = 0.0
		bone = bone_preload.instance()
		$Bones_2.add_child(bone)
		bone._resize_bullet(
			box_size_arena.rect_size.x - 10, 10, 
			box_size_main.rect_position.y + box_size_arena.rect_size.y - 20, 15, 
			0.0, 
			3, "left", - box_size_arena.rect_size.x + 4
		)
	
	if index_3 >= 20.0:
		index_3 = 0.0
		bone = bone_preload.instance()
		$Bones_3.add_child(bone)
		bone._resize_bullet(
			box_size_arena.rect_size.x - 10, 10, 
			box_size_main.rect_position.y + box_size_arena.rect_size.y - 50, 32, 
			0.0, 
			3, "left", - box_size_arena.rect_size.x + 4
		)
		bone._rotate_bone(
			20.0, 0.0, 1.0
		)
		_color_modulate(bone)
		

	if index_4 >= 28.0:
		index_4 = 0.0
		bone = bone_preload.instance()
		$Bones_4.add_child(bone)
		bone._resize_bullet(
			- 8, 10, 
			10, 80, 
			0.1, 
			2, "right", box_size_arena.rect_size.x
		)
		bone._rotate_bone(
			90.0, 0.0, 1.0
		)
		_color_modulate(bone)
		
		
	if index_pellet_1 >= 80.0:
		index_pellet_1 = 0.0
		pellet = pellet_preload.instance()
		
		var posx = 0.0
		var posy = 0.0
		var dir = ""
		var margin = 0.0
		sideDet = rand_range(0.0, 2.0)
		
		if int(sideDet) == 0:
			posx = box_size_main.rect_position.x - 8
			posy = rand_range(30.0, box_size_arena.rect_size.y - 30.0)
			dir = "right"
			margin = box_size_arena.rect_size.x
			
		if int(sideDet) == 1:
			posx = box_size_arena.rect_size.x
			posy = rand_range(30.0, box_size_arena.rect_size.y - 30.0)
			dir = "left"
			margin = 4
		
		pellet._cast_bullet(posx, posy, deltavar * 2.5, dir, margin)
		pellet.side = int(sideDet)
		
		$Pellets_1.add_child(pellet)
		
		
	if index_blaster_1 >= 70.0:
		index_blaster_1 = 0.0
		blaster = blaster_preload.instance()
		get_node("/root/Battle_Engine").add_child(blaster)
		
		var soulpos = get_node("/root/Battle_Engine/Player_Soul")
		blaster._cast_blaster(700.0, soulpos.position.y, 550.0, soulpos.position.y, 30.0, 90.0, 0.6, 0.8)
	
func _count_index(delta):
	deltavar = 1
	
	indexGlobal += deltavar
	
	index_1 += deltavar
	index_2 += deltavar
	index_3 += deltavar
	index_4 += deltavar
	
	index_pellet_1 += deltavar
	
	index_blaster_1 += deltavar

func _get_collisions(collision, shape):
	collision.position.y = shape.rect_position.y + (shape.rect_size.y / 2.0)
	collision.position.x = shape.rect_position.x + (shape.rect_size.x / 2.0)
	collision.shape.extents = Vector2((shape.rect_size.x / 2.0) - 3.0, (shape.rect_size.y / 2.0) - 3.0)

func _color_modulate(bone):
	color_det = int(rand_range(1, 7))
	if color_det == 1: bone.modulate = Color(0, 0.858, 0.98)
	if color_det == 2: bone.modulate = Color(1, 0.505, 0.019)
	
