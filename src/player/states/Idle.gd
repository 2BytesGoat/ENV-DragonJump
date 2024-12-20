extends State
class_name PlayerIdle


func enter(_msg := {}) -> void:
	owner.x_strength = 0
	owner.y_strength = 0
	owner.velocity.x *= 0.4
	owner.play_animation(self.name)

func update(_delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	elif owner.started_walking:
		state_machine.transition_to("Run")
