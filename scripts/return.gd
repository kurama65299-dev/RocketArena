extends Button
@onready var play_settings: Panel = $".."
@onready var players: Panel = $"../Players"
@onready var game_settings: Panel = $"../GameSettings"

func _on_button_down() -> void:
	play_settings.visible = false
	players.visible = false
	game_settings.visible = false
