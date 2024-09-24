extends State
class_name PlayerFall

@export var y_curve: Curve
var time = 0.0

func enter(_msg := {}) -> void:
	time = 0.0
	owner.y_strength = y_curve.sample(time)
	owner.play_animation(self.name)

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.y_strength = y_curve.sample(time)
	if owner.is_on_wall():
		state_machine.transition_to("Walled")

func update(_delta: float) -> void:
	if owner.is_on_floor():
		owner.velocity *= 0.5
		state_machine.transition_to("Idle")
