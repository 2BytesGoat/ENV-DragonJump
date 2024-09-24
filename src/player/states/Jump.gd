extends State
class_name PlayerJump

@onready var jump_timer = $JumpTimer
@export var y_curve: Curve
var time = 0.0


func enter(_msg := {}) -> void:
	time = 0.0
	owner.velocity.y = 0
	owner.x_strength = 1
	owner.y_strength = y_curve.sample(time)
	owner.play_animation(self.name)
	jump_timer.start()

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		if owner.is_on_wall():
			state_machine.transition_to("Walled")
		else:
			state_machine.transition_to("Fall")

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.y_strength = y_curve.sample(time)

func _on_jump_timer_timeout() -> void:
	if owner.is_on_wall():
		state_machine.transition_to("Walled")
	else:
		state_machine.transition_to("Fall")
