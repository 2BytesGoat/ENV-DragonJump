extends Control

@onready var ui_components = [
	%HumanContainer,
	%TrainingContainer
]
var listening_for_key = false
var new_jump_button = "Space"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = not visible
		LevelState.game_paused = visible

	if listening_for_key and event is InputEventKey and event.pressed:
		var key_name = OS.get_keycode_string(event.keycode)
		new_jump_button = key_name
		%JumpButtonLabel.text = key_name
		%JumpButtonEdit.disabled = false
		listening_for_key = false

func _on_option_button_item_selected(index: int) -> void:
	for i in range(len(ui_components)):
		if index == i:
			ui_components[i].visible = true
		else:
			ui_components[i].visible = false

func _on_jump_button_edit_pressed() -> void:
	%JumpButtonEdit.disabled = true
	%JumpButtonEdit.focus_mode = 0
	%JumpButtonLabel.text = "Listening for key..."
	listening_for_key = true

func _on_apply_button_pressed() -> void:
	visible = false
	GameState.JUMP_BUTTON = new_jump_button
	LevelState.game_paused = false
