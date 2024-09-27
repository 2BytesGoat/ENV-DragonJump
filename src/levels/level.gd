extends Node2D

@onready var bg_layer = $BackgroundLayer

var map_code = "W40/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W1E38W1/W13E26W1/W1E38W1/W1E18W9E11W1/W1E38W1/W1E38W1/W1E38W1/W1E32W7/W1E32W1E6/W1E21W7E4W1E6/W1E32W1E6/W1E11W6E15W1E6/W13E4W1E15W1E6/E17W17E6"
var offset = Vector2i(0, -10)

func _ready():
	set_map_code()

func get_map_code():
	var map_sub_codes = []
	var map_size = bg_layer.get_used_rect().size
	var map_offset = bg_layer.get_used_rect().position
	
	for y in range(map_size.y):
		var sub_code = ""
		var current_symbol = "E"
		var current_symbol_cnt = 0
		for x in range(map_size.x):
			var tile_data = bg_layer.get_cell_tile_data(Vector2i(x, y) + map_offset)
			var tile_symbol = "E"
			if tile_data != null:
				tile_symbol = "W"
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
	for i in range(symbol_cnt):
		bg_layer.set_cell(offset + Vector2i(i, 0), 0, Vector2i(3, 3))
