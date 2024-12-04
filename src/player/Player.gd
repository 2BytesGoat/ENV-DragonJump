extends CharacterBody2D
class_name Player

var MAX_SPEED = Vector2(190, 200)
var ACCELERATION = 5200

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var state_machine = $StateMachine
@onready var state_label = $StateLabel
@onready var ai_controller = $AIController2D

@export var target_camera: Camera2D

var modifiers = {}
var started_walking = false : set = _set_started_walking

var facing_direction = 1 # 1 is RIGHT -1 is LEFT
var x_strength = 0
var y_strength = 0
var jump_action = false
var keyboard_jump_action = false

var init_position = Vector2.ZERO

signal player_restart


func _ready() -> void:
	ai_controller.init(self)
	game_over()

func _input(event: InputEvent) -> void:
	if not started_walking:
		return
	if event.is_action_pressed("ui_accept"):
		keyboard_jump_action = true
	elif event.is_action_released("ui_accept"):
		keyboard_jump_action = false
	if event.is_action_pressed("player_reset"):
		game_over()

func _process(_delta: float) -> void:
	var player_id = get_instance_id()
	GameState.player_info[player_id] = {
		"goal_distance": get_goal_distance(),
		"global_position": global_position
	}

func _physics_process(delta: float) -> void:
	var target_speed = Vector2(x_strength * facing_direction, y_strength) * MAX_SPEED
	velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	
	for mod in modifiers.values():
		velocity *= mod["velocity"]
	
	move_and_slide()
	update_sprite_facing_direction()
	
	state_label.text = state_machine.state.name

func get_jump_action() -> bool:
	if ai_controller.done:
		jump_action = false
	return jump_action

func set_jump_action(value) -> void:
	jump_action = value
	keyboard_jump_action = value

func update_sprite_facing_direction() -> void:
	sprite.scale.x = facing_direction

func get_goal_distance():
	var goal_position = GameState.goal_global_position
	var goal_distance = global_position.distance_to(goal_position)
	return goal_distance

func update_reward() -> void:
	ai_controller.reward -= 0.01  # step penalty
	ai_controller.reward += 1 - get_goal_distance() # the cloaser you are

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func game_over() -> void:
	if ai_controller.heuristic == "human":
		started_walking = false
	else:
		started_walking = true
	
	modifiers = {}
	facing_direction = 1
	x_strength = 0
	y_strength = 0
	jump_action = false
	keyboard_jump_action = false
	
	state_machine.reset()
	velocity = Vector2.ZERO
	global_position = init_position
	
	ai_controller.reset()
	player_restart.emit()
	LevelState.reset()

func _set_started_walking(value: bool) -> void:
	started_walking = value
	LevelState.game_paused = not value

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("EXIT"):
		ai_controller.reward += 100
		ai_controller.needs_reset = true
		ai_controller.done = true
		LevelState.game_ended = true

func _on_level_init_player_position_updated(value: Vector2) -> void:
	init_position = value
