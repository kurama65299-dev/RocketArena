extends Panel
@onready var maps: Panel = $"."
@onready var players: Panel = $"../Players"

func _on_spiky_battle_button_down() -> void:
	GlobalSettings.map = "SpikyBattle"

func _on_descending_war_button_down() -> void:
	GlobalSettings.map = "DescendingWar"

func _on_next_button_down() -> void:
	players.visible = true
	maps.visible = false

func _on_gamemode_item_selected(index: int) -> void:
	if index == 0:
		GlobalSettings.gamemode = "free_for_all"
		GlobalSettings.teams_enabled = false
	elif index == 1:
		GlobalSettings.gamemode = "keep_the_briefcase"
		GlobalSettings.teams_enabled = true
