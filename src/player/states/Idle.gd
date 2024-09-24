extends State


func enter(_msg := {}) -> void:
	owner.play_animation(self.name)
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
	elif owner.started_walking:
		state_machine.transition_to("Run")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		owner.started_walking = true
		state_machine.transition_to("Run")
