extends Node

var show_camera_preview = false

var game_paused = false
var game_ended = false : set = _set_game_ended

var elapsed_time = 0.0


func _process(delta: float) -> void:
	if game_paused or game_ended:
		return
	elapsed_time += int(delta * 1000)

func _set_game_ended(value: bool) -> void:
	game_ended = value

func reset() -> void:
	game_ended = false
	elapsed_time = 0.0
