extends Node2D

@onready var bg_layer = $BackgroundLayer
@onready var scene_layer = $ScenesLayer
@onready var objects_layer = $Objects

const symbol_to_cell_info = {
	"W": {
		"type": "background",
		"source": 0,
		"coords": Vector2i(3, 3)
	},
	"P": {
		"type": "scene",
		"source": 0,
		"coords": Vector2i(0, 0)
	},
	"Q": {
		"type": "scene",
		"source": 0,
		"coords": Vector2i(1, 1)
	}
}

const symbol_to_scene = {
	"P": preload("res://src/player/player.tscn"),
	"Q": preload("res://src/scenes/exit.tscn")
}

const level_1 = "W75/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E73W1/W1E2P1E70W1/W1E70Q1E2W1/W1E67W7/W1E47W9E11W1E6/W1E30W7E10W1E7W1E11W1E6/W1E16W6E8W1E5W1E10W1E7W1E11W1E6/W18E4W10E5W12E7W13E6"
const level_2 = "W40/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E1Q1E36W1/W13E26W1/W1E38W1/W1E18W9E11W1/W1E38W1/W1E38W1/W1E38W1/W1E32W7/W1E32W1E6/W1E2P1E18W7E4W1E6/W1E32W1E6/W1E11W6E15W1E6/W13E4W1E15W1E6/E17W17E6"

var map_code = level_1
var offset = Vector2i(0, -10)
var tilemap_scene_locations = {}


func _ready():
	print(get_map_code())
	#map_code = get_map_code()
	reset_map()

func get_map_code():
	var map_sub_codes = []
	var map_size = bg_layer.get_used_rect().size
	var map_offset = bg_layer.get_used_rect().position
	
	for y in range(map_size.y):
		var sub_code = ""
		var current_symbol = "E"
		var current_symbol_cnt = 0
		for x in range(map_size.x):
			var tile_symbol = "E"
			var bg_tile_data = bg_layer.get_cell_tile_data(Vector2i(x, y) + map_offset)
			if bg_tile_data != null:
				tile_symbol = "W"
			var scene_tile_data = scene_layer.get_cell_tile_data(Vector2i(x, y) + map_offset)
			if scene_tile_data != null:
				tile_symbol = scene_tile_data.get_custom_data("Symbol")
			if tile_symbol == current_symbol:
				current_symbol_cnt += 1
			else:
				if current_symbol_cnt > 0:
					sub_code += "%s%s"%[current_symbol, current_symbol_cnt]
				current_symbol = tile_symbol
				current_symbol_cnt = 1
		if current_symbol_cnt > 0:
			sub_code += "%s%s"%[current_symbol, current_symbol_cnt]
		map_sub_codes.append(sub_code)
	return "/".join(map_sub_codes)

func set_map_code():
	var y = 0
	var map_code_offset = offset
	for map_sub_code in map_code.split("/"):
		var current_symbol = "E"
		var current_symbol_cnt = 0
		var x = 0
		for character in map_sub_code:
			if character.is_valid_int():
				current_symbol_cnt = current_symbol_cnt * 10 + int(character)
			elif character != current_symbol:
				if current_symbol_cnt > 0:
					set_multiple_map_cells(current_symbol, current_symbol_cnt, map_code_offset + Vector2i(x, y))
				x += current_symbol_cnt
				current_symbol = character
				current_symbol_cnt = 0
		if current_symbol_cnt > 0:
			set_multiple_map_cells(current_symbol, current_symbol_cnt, map_code_offset + Vector2i(x, y))
		y += 1

func set_multiple_map_cells(symbol, symbol_cnt, offset):
	if symbol == "E":
		return
	
	var cell_info = symbol_to_cell_info[symbol]
	var tilemap_layer = bg_layer
	if cell_info["type"] == "scene":
		tilemap_layer = scene_layer
		if symbol not in tilemap_scene_locations:
			tilemap_scene_locations[symbol] = []
	
	for i in range(symbol_cnt):
		tilemap_layer.set_cell(offset + Vector2i(i, 0), cell_info["source"], cell_info["coords"])
		if cell_info["type"] == "scene":
			tilemap_scene_locations[symbol].append(offset + Vector2i(i, 0))
	
func load_scenes():
	for symbol in tilemap_scene_locations:
		var scene_locations = tilemap_scene_locations[symbol]
		for location in scene_locations:
			scene_layer.erase_cell(location)
			var obj_scene = symbol_to_scene[symbol]
			var obj_position = scene_layer.to_global(scene_layer.map_to_local(location))
			var obj = obj_scene.instantiate()
			objects_layer.add_child(obj)
			obj.global_position = obj_position
			
			if symbol == "P":
				## should fix this in future to have them connected
				#obj.player_restart.connect(reset_map)
				obj.init_position = obj_position
				pass
			if symbol == "Q":
				GameState.goal_global_position = obj_position

func clear_map():
	for child in objects_layer.get_children():
		objects_layer.remove_child(child)
		child.queue_free()
	for cell in bg_layer.get_used_cells():
		bg_layer.erase_cell(cell)
	for cell in scene_layer.get_used_cells():
		scene_layer.erase_cell(cell)
	tilemap_scene_locations = {}

func reset_map():
	clear_map() 
	set_map_code()
	load_scenes()
