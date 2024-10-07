extends State
class_name PlayerRun

@onready var coyotee_timer = $CoyoteeTimer
@export var x_curve: Curve
var time = 0.0


func enter(_msg := {}) -> void:
	time = 0.5
	owner.x_strength = x_curve.sample(time)
	owner.play_animation(self.name)

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.x_strength = x_curve.sample(time)
	if not owner.is_on_floor() and coyotee_timer.is_stopped():
		coyotee_timer.start()
	if owner.is_on_wall():
		time = 0.0
		owner.facing_direction *= -1
	
	if owner.get_jump_action():
		coyotee_timer.stop()
		state_machine.transition_to("Jump")

func _on_coyotee_timer_timeout() -> void:
	state_machine.transition_to("Fall")
