extends State
class_name PlayerFall


func enter(_msg := {}) -> void:
	# TODO: Replace this with curve
	owner.y_strength = 1
	owner.play_animation(self.name)

func physics_update(delta: float) -> void:
	if owner.is_on_wall():
		state_machine.transition_to("Walled")

func update(_delta: float) -> void:
	if owner.is_on_floor():
		owner.velocity *= 0.5
		state_machine.transition_to("Idle")
