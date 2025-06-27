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
