extends Node2D

var all_players = []

func _input(event: InputEvent) -> void:
	if len(all_players) == 0 and event.is_action_pressed("ui_accept"):
		all_players = get_tree().get_nodes_in_group("PLAYER")
	
	for player in all_players:
		if not player.started_walking:
			player.started_walking = true
		player._input(event)
