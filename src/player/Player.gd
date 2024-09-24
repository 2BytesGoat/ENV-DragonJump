extends CharacterBody2D

var MAX_SPEED = 220
var ACCELERATION = 1800

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var started_walking = false
var facing_direction = 1
var input_x = 0
var input_y = 0


func _physics_process(delta: float) -> void:
	var target_speed = Vector2(input_x, input_y) * MAX_SPEED
	velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	move_and_slide()
	update_facing_direction()

func update_facing_direction() -> void:
	if input_x != 0:
		facing_direction = sign(input_x)
	sprite.scale.x = facing_direction

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)
