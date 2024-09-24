extends State


func enter(_msg := {}) -> void:
	owner.input_x = owner.facing_direction
	owner.play_animation(self.name)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state_machine.transition_to("Jump")

func physics_update(_delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	elif owner.is_on_wall():
		owner.input_x *= -1
