extends CharacterBody2D
class_name Player

var MAX_SPEED = Vector2(180, 200)
var ACCELERATION = 5200

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var state_label = $StateLabel

var modifiers = {}
var started_walking = false

var facing_direction = 1 # 1 is RIGHT -1 is LEFT
var x_strength = 0
var y_strength = 0


func _physics_process(delta: float) -> void:
	var target_speed = Vector2(x_strength * facing_direction, y_strength) * MAX_SPEED
	velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	
	for mod in modifiers.values():
		velocity *= mod["velocity"]
	
	move_and_slide()
	update_sprite_facing_direction()
	
	state_label.text = $StateMachine.state.name

func update_sprite_facing_direction() -> void:
	sprite.scale.x = facing_direction

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)
