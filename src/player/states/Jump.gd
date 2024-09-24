extends State
class_name PlayerJump

@onready var jump_timer = $JumpTimer


func enter(_msg := {}) -> void:
	owner.x_strength = 1
	owner.y_strength = -1
	owner.velocity.y = 0
	owner.play_animation(self.name)
	jump_timer.start()

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		if owner.is_on_wall():
			state_machine.transition_to("Walled")
		else:
			state_machine.transition_to("Fall")

func _on_jump_timer_timeout() -> void:
	if owner.is_on_wall():
		state_machine.transition_to("Walled")
	else:
		state_machine.transition_to("Fall")
