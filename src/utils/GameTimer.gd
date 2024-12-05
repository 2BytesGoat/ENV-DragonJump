extends Label


func _process(_delta: float) -> void:
	text = str(Utils.format_time(LevelState.elapsed_time))
