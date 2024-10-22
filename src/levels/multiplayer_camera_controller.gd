extends Node

@onready var multiplayer_camera = $"../MultiplayerCamera2D"


func _process(delta: float) -> void:
	multiplayer_camera.global_position = GameState.closest_player_position
