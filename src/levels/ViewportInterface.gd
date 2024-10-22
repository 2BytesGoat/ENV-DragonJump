extends Node2D

@onready var p_viewport = $"../PlayerViewport"
@onready var mp_viewport = $"../SubViewport"

var all_players = []


func _ready():
	all_players = get_tree().get_nodes_in_group("PLAYER")
	mp_viewport.world_2d = p_viewport.world_2d

func _input(event: InputEvent) -> void:
	for player in all_players:
		if not player.started_walking:
			player.started_walking = true
		player._input(event)
