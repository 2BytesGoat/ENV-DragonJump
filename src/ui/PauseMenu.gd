extends Control

@onready var control_components = [
	%HumanContainer,
	%TrainingContainer
]
@onready var tab_components = [
	%InfoPanel,
	%SettingsPanel
]

var listening_for_key = false
var new_jump_button = "Space"


func _ready():
	%RecordingsSavePath.text = GameState.RECORDINGS_PATH

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
	for i in range(len(control_components)):
		if index == i:
			control_components[i].visible = true
		else:
			control_components[i].visible = false

func _on_jump_button_edit_pressed() -> void:
	%JumpButtonEdit.disabled = true
	%JumpButtonEdit.focus_mode = 0
	%JumpButtonLabel.text = "Listening for key..."
	listening_for_key = true

func _on_apply_button_pressed() -> void:
	visible = false
	GameState.JUMP_BUTTON = new_jump_button
	LevelState.needs_reset = true

func _on_recordings_save_path_button_pressed() -> void:
	%SavePathDialog.visible = true

func _on_tab_bar_tab_clicked(tab: int) -> void:
	for i in range(len(tab_components)):
		if tab == i:
			tab_components[i].visible = true
		else:
			tab_components[i].visible = false
