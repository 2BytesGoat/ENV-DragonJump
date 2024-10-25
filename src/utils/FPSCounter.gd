extends Label


func _process(_delta: float) -> void:
	text = "FPS: %s" % str(Engine.get_frames_per_second())
