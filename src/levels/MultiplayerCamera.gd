extends Camera2D


func _process(_delta: float) -> void:
	global_position = GameState.closest_player_position
