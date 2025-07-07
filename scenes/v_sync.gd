extends HBoxContainer

@onready var checkbox: CheckBox = $Checkbox

func _ready():
	checkbox.button_pressed = DisplayServer.window_get_vsync_mode()

func _on_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
