extends State

@onready var jump_timer = $JumpTimer


func enter(_msg := {}) -> void:
	owner.input_x = owner.facing_direction
	owner.input_y = -1
	owner.play_animation(self.name)
	jump_timer.start()

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		state_machine.transition_to("Fall")

func physics_update(delta: float) -> void:
	if owner.is_on_wall():
		state_machine.transition_to("Walled")

func _on_jump_timer_timeout() -> void:
	state_machine.transition_to("Fall")
