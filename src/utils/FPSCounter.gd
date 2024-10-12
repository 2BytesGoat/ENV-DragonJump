extends Label


func _process(delta: float) -> void:
	text = "FPS: %s" % str(Engine.get_frames_per_second())
