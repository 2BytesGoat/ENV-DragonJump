extends State
class_name PlayerRun


func enter(_msg := {}) -> void:
	owner.x_strength = 1
	owner.play_animation(self.name)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state_machine.transition_to("Jump")

func physics_update(_delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	elif owner.is_on_wall():
		owner.facing_direction *= -1
