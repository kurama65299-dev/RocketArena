extends Button
@onready var play_settings: Panel = $".."
@onready var maps: Panel = $"../Maps"
@onready var players: Panel = $"../Players"

func _on_button_down() -> void:
	play_settings.visible = false
	players.visible = false
