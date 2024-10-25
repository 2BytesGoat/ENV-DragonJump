extends Node

# TODO: get these from the game state
var frame_w = 512 / 2
var frame_h = 512 / 2

var goal_global_position = Vector2.ZERO
var player_info = {}

var closest_player_position = Vector2.ZERO


func _process(_delta: float) -> void:
	var min_distance = INF
	var closest_player = null
	for player_name in player_info:
		if player_info[player_name]["goal_distance"] < min_distance:
			min_distance = player_info[player_name]["goal_distance"]
			closest_player = player_name
	if closest_player == null:
		return
	closest_player_position = player_info[closest_player]["global_position"]
