extends AIController2D


func _physics_process(_delta):
	if control_mode == ControlModes.HUMAN:
		set_action()
	
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
	
	var clamped_goal_distance = clamp(goal_distance, 0.0, 20.0) / 20.0
	
	var obs = {
		"goal_distance": clamped_goal_distance,
		"goal_vector": [goal_vector.x, goal_vector.y],
		"player_velocity": [velocity_vector.x, velocity_vector.y],
		"sensors": _player.raycast_sensor.get_observation()
	}
	
	var frame = get_viewport().get_texture().get_image()
	var resize_w = GameState.frame_w
	var resize_h = GameState.frame_h
	frame.resize(resize_w, resize_h, Image.INTERPOLATE_NEAREST)
	
	var frame_data = frame.data
	var encoded_frame = frame_data["data"].hex_encode()
	
	return {"obs_2d": encoded_frame, "obs": obs}

func get_obs_space():
	# may need overriding if the obs space is complex
	var obs = get_obs()
	return {
		"obs": {"size": [len(obs["obs"])], "space": "box"},
		"obs_2d": {"size": [GameState.frame_h, GameState.frame_w, 3], "space": "box"}
	}

func get_info():
	return {}

func get_action():
	return {"jump": int(_player.get_jump_action())}

func set_action(action = null):
	if action:
		_player.jump_action = action["jump"] > 0
	else:
		_player.jump_action = _player.keyboard_jump_action

func get_action_space():
	return {
		"jump": {"size": 2, "action_type": "discrete"},
	}

func get_reward():
	var current_reward = reward
	reward = 0  # reset the reward to zero checked every decision step
	return current_reward
