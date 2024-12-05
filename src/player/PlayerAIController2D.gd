extends AIController2D

@onready var raycast_sensor = $RaycastSensor2D
@onready var camera_sensor = $RGBCameraSensor2D


func _ready() -> void:
	super()
	raycast_sensor.activate()

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
	
	var obs = [
		clamped_goal_distance, # goal_distance
		goal_vector.x, goal_vector.y, # goal_vector
		velocity_vector.x, velocity_vector.y # player_velocity
	]
	# sensors
	obs.append_array(raycast_sensor.get_observation())
	
	var obs_2d = get_image_obs()
	
	return {"obs": obs, "obs_2d": obs_2d}

func get_obs_space():
	# may need overriding if the obs space is complex
	var obs = get_obs()
	
	return {
		"obs": {"size": [len(obs["obs"])], "space": "box"},
		"obs_2d": {"size": camera_sensor.get_camera_shape(), "space": "box"}
	}

func get_info():
	return {}

func get_action():
	return {"jump": int(_player.get_jump_action())}

func get_image_obs() -> String:
	return camera_sensor.get_camera_pixel_encoding()

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
