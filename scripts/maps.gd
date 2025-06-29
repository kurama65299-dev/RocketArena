extends Panel
@onready var game_settings: Panel = $"."
@onready var players: Panel = $"../Players"

func _on_spiky_battle_button_down() -> void:
	GlobalSettings.map = "SpikyBattle"

func _on_descending_war_button_down() -> void:
	GlobalSettings.map = "DescendingWar"

func _on_next_button_down() -> void:
	players.visible = true
	game_settings.visible = false

func _on_gamemode_item_selected(index: int) -> void:
	if index == 0:
		GlobalSettings.gamemode = "free_for_all"
		GlobalSettings.teams_enabled = false
	elif index == 1:
		GlobalSettings.gamemode = "keep_the_briefcase"
		GlobalSettings.teams_enabled = true

func _on_spin_box_value_changed(value: float) -> void:
	GlobalSettings.time = value
