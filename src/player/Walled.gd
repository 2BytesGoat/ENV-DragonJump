extends State


func enter(_msg := {}) -> void:
	owner.input_x = 0
	owner.input_y = 0.85
	owner.facing_direction *= -1
	owner.play_animation(self.name)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state_machine.transition_to("Jump")

func update(_delta: float) -> void:
	if owner.is_on_floor():
		owner.velocity *= 0.5
		state_machine.transition_to("Idle")
