extends Button

@onready var play_settings: Panel = $"../PlaySettings"
@onready var game_settings: Panel = $"../PlaySettings/GameSettings"

func _on_button_down() -> void:
	play_settings.visible = true
	game_settings.visible = true
