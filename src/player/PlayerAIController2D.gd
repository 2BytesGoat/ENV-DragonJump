extends AIController2D


func _physics_process(_delta):
	n_steps += 1
	if n_steps >= reset_after:
		done = true
		needs_reset = true

	if needs_reset:
		_player.game_over()

func get_obs():
	""" What needs to go in obs
	goal_distance, goal_vector, player_velocity, raycasts, player_state
	"""
	var goal_position = GameState.goal_global_position
	var goal_vector = _player.to_local(goal_position).normalized()
	var goal_distance = _player.get_goal_distance()
	var velocity_vector = _player.velocity / _player.MAX_SPEED
	
	var obs = {
		"goal_distnace": goal_distance,
		"goal_vector": [goal_vector.x, goal_vector.y],
		"player_velocity": [velocity_vector.x, velocity_vector.y],
		"sensors": _player.raycast_sensor.get_observation()
	}
	
	var frame = get_viewport().get_texture().get_image()
	var resize_w = frame.data["width"] / 4
	var resize_h = frame.data["height"] / 4
	frame.resize(resize_w, resize_h, Image.INTERPOLATE_NEAREST)
	
	return {"frame": frame.data, "obs": obs}

func get_info():
	return {}

func set_action(action):
	_player.jump_action = action["jump"] > 0

func get_action_space():
	return {
		"jump": {"size": 2, "action_type": "discrete"},
	}

func get_reward():
	var current_reward = reward
	reward = 0  # reset the reward to zero checked every decision step
	return current_reward
