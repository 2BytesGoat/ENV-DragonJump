extends State
class_name PlayerWalled

@export var y_curve: Curve
var time = 0.0


func enter(_msg := {}) -> void:
	# TODO: Replace this with curve
	time = 0.0
	owner.facing_direction *= -1
	owner.y_strength = y_curve.sample(time)
	owner.modifiers["walled"] = {"velocity": Vector2(-0.1, 1)}
	owner.play_animation(self.name)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.y_strength = y_curve.sample(time)
	
	if owner.is_on_floor():
		owner.velocity *= 0.5
		state_machine.transition_to("Idle")
	elif not owner.is_on_wall():
		state_machine.transition_to("Fall")

func exit() -> void:
	owner.x_strength = 0
	owner.modifiers.erase("walled")
