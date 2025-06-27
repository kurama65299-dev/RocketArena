extends Button

@onready var play_settings: Panel = $"../../PlaySettings"
@onready var maps: Panel = $"../../PlaySettings/Maps"

func _on_button_down() -> void:
	play_settings.visible = true
	maps.visible = true
