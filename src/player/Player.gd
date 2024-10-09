extends CharacterBody2D
class_name Player

var MAX_SPEED = Vector2(190, 200)
var ACCELERATION = 5200

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var state_label = $StateLabel
@onready var ai_controller = $AIController2D

var modifiers = {}
var started_walking = false

var facing_direction = 1 # 1 is RIGHT -1 is LEFT
var x_strength = 0
var y_strength = 0
var jump_action = false
var player_jump_action = false

signal player_restart


func _ready() -> void:
	ai_controller.init(self)

func _input(event: InputEvent) -> void:
	if not started_walking:
		return
	if event.is_action_pressed("ui_accept"):
		player_jump_action = true
	elif event.is_action_released("ui_accept"):
		player_jump_action = false
	if event.is_action_pressed("ui_cancel"):
		player_restart.emit()

func _physics_process(delta: float) -> void:
	var target_speed = Vector2(x_strength * facing_direction, y_strength) * MAX_SPEED
	velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	
	for mod in modifiers.values():
		velocity *= mod["velocity"]
	
	move_and_slide()
	update_sprite_facing_direction()
	
	state_label.text = $StateMachine.state.name

func get_jump_action() -> bool:
	if ai_controller.heuristic == "model":
		if ai_controller.done:
			jump_action = false
		return jump_action

	return player_jump_action

func set_jump_action(action: bool) -> void:
	# it should only affect the player such that
	# the character doesn't bunny hop whenever it touches the floor
	player_jump_action = action

func update_sprite_facing_direction() -> void:
	sprite.scale.x = facing_direction

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func game_over() -> void:
	player_restart.emit()
