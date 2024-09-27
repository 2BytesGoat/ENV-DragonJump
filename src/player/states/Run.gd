extends State
class_name PlayerRun

@export var x_curve: Curve
var time = 0.0


func enter(_msg := {}) -> void:
	time = 0.5
	owner.x_strength = x_curve.sample(time)
	owner.play_animation(self.name)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.x_strength = x_curve.sample(time)
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	elif owner.is_on_wall():
		time = 0.0
		owner.facing_direction *= -1
