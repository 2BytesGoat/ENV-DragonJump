extends State
class_name PlayerWalled

@export var y_curve: Curve
var time = 0.0


func enter(_msg := {}) -> void:
	time = 0.0
	var walled_direction = get_walled_direction()
	if walled_direction != Vector2.ZERO:
		owner.facing_direction = walled_direction.x
	owner.y_strength = y_curve.sample(time)
	# TODO: find a better way to add modifiers
	owner.modifiers["walled"] = {"velocity": Vector2(-0.01, 1)}
	owner.play_animation(self.name)

func physics_update(delta: float) -> void:
	time = min(time + delta, 1)
	owner.y_strength = y_curve.sample(time)
	
	if owner.is_on_floor():
		owner.velocity *= 0.5
		state_machine.transition_to("Idle")
	elif not owner.is_on_wall():
		state_machine.transition_to("Fall")
	elif owner.get_jump_action():
		state_machine.transition_to("Jump")

func exit() -> void:
	owner.x_strength = 0
	owner.modifiers.erase("walled")

func get_walled_direction():
	var collision = owner.get_last_slide_collision()
	if collision:
		var normal = collision.get_normal()
		if abs(normal.x) > abs(normal.y):  # Check if the collision is mostly horizontal
			return normal
	return Vector2.ZERO
