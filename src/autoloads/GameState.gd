extends Node

var JUMP_BUTTON = "Space"
var RECORDINGS_PATH = ""

# TODO: get these from the game state
var frame_w = 512 / 2
var frame_h = 512 / 2

var goal_global_position = Vector2.ZERO
var player_info = {}

var closest_player_position = Vector2.ZERO

func _ready() -> void:
	RECORDINGS_PATH = get_desktop_path()

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

func get_desktop_path() -> String:
	# Attempt to locate the desktop path dynamically
	if OS.has_environment("XDG_DESKTOP_DIR"):
		return OS.get_environment("XDG_DESKTOP_DIR")  # Linux with XDG
	elif OS.get_name() == "Windows":
		return OS.get_environment("USERPROFILE") + "\\Desktop"  # Windows
	elif OS.get_name() == "OSX":
		return OS.get_environment("HOME") + "/Desktop"  # macOS
	else:
		return OS.get_environment("HOME") + "/Desktop"  # Linux fallback
