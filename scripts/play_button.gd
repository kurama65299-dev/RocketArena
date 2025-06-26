extends Button

@onready var play_settings: Panel = $"../../PlaySettings"

func _on_button_down() -> void:
	play_settings.visible = !play_settings.visible
