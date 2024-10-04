extends State
class_name PlayerJump

@onready var jump_timer = $JumpTimer
@export var y_curve: Curve
var time = 0.0
var was_on_wall = false


func enter(_msg := {}) -> void:
	time = 0.0
	was_on_wall = false
	owner.x_strength = 1
	owner.y_strength = y_curve.sample(time)
	owner.velocity.y = 0
	owner.play_animation(self.name)
	jump_timer.start()

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		jump_timer.stop()
		_on_jump_timer_timeout()

func physics_update(delta: float) -> void:
	if owner.is_on_wall():
		was_on_wall = true
	if was_on_wall and not owner.is_on_wall() and time == 1:
		jump_timer.stop()
		state_machine.transition_to("Run")
	time = min(time + delta, 1)
	owner.y_strength = y_curve.sample(time)

func _on_jump_timer_timeout() -> void:
	if owner.is_on_wall():
		state_machine.transition_to("Walled")
	else:
		state_machine.transition_to("Fall")
