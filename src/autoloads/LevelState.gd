extends Node

var show_camera_preview = false

var game_started = false
var game_paused = false
var game_ended = false : set = _set_game_ended

var elapsed_time = 0.0
var best_time = INF

var level_name = "Level 1"
var leaderboard_found = false

func _ready() -> void:
	Steam.leaderboard_find_result.connect(_on_leaderboard_found)
	Steam.leaderboard_scores_downloaded.connect(_on_leaderboard_score_downloaded)
	GodotSteam.find_or_create_leaderboard(level_name)

func _process(delta: float) -> void:
	if not game_started or game_paused or game_ended:
		return
	elapsed_time += int(delta * 1000)

func _set_game_ended(value: bool) -> void:
	if value:
		best_time = min(elapsed_time, best_time)
		if leaderboard_found:
			GodotSteam.submit_leaderboard_score(best_time)
		elapsed_time = 0.0
	game_ended = value

func reset() -> void:
	elapsed_time = 0.0
	game_started = false
	game_paused = false
	game_ended = false

func _on_leaderboard_found(_handle, found) -> void:
	leaderboard_found = bool(found)
	if leaderboard_found:
		GodotSteam.download_leaderboard_score()

func _on_leaderboard_score_downloaded(message, handle, result) -> void:
	if len(result) > 0:
		best_time = result[0]["score"]
