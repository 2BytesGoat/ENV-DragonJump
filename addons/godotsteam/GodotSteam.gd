extends Node

# Steam variables
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_app_id: int = 3111120
var steam_id: int = 0
var steam_username: String = ""


func _init() -> void:
	# Set your game's Steam app ID here
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))

func _ready() -> void:
	Steam.leaderboard_find_result.connect(_on_leaderboard_found)
	Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
	Steam.leaderboard_scores_downloaded.connect(_on_leaderboard_score_downloaded)
	initialize_steam()
	print('done init')

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s" % initialize_response)

	if initialize_response['status'] > 0:
		print("Failed to initialize Steam. Shutting down. %s" % initialize_response)
		get_tree().quit()

	# Gather additional data
	is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
	is_online = Steam.loggedOn()
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()

	# Check if account owns the game
	if is_owned == false:
		print("User does not own this game")
		get_tree().quit()

func find_or_create_leaderboard(leaderbaord_name: String) -> void:
	Steam.findOrCreateLeaderboard(leaderbaord_name, Steam.LEADERBOARD_SORT_METHOD_ASCENDING, Steam.LEADERBOARD_DISPLAY_TYPE_TIME_MILLISECONDS)

func submit_leaderboard_score(time_ms: int) -> void:
	Steam.uploadLeaderboardScore(time_ms)

func download_leaderboard_score() -> void:
	Steam.downloadLeaderboardEntries(0, 10)
	
func _on_leaderboard_found(handle, found) -> void:
	#print("leaderboard handle: ", handle, " found: ", found)
	pass

func _on_leaderboard_score_uploaded(success, handle, score) -> void:
	#print("success: ", success, " leaderboard handle: ", handle, " score: ", score)
	pass

func _on_leaderboard_score_downloaded(message, handle, result) -> void:
	#print("here ", message, handle, result)
	pass
