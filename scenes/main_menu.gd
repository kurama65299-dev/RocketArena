extends CanvasLayer

@onready var main_panel: Panel = $MainPanel
@onready var settings_panel: Panel = $SettingsPanel
@onready var lobby_panel: Panel = $LobbyPanel

var current_panel = "MAIN"

func _ready():
	update_panel_visibility()

func update_panel_visibility():
	for child in get_children():
		if child is Panel:
			child.visible = false
			
	match current_panel:
		"MAIN":
			main_panel.visible = true
		"LOBBY":
			main_panel.visible = true
			lobby_panel.visible = true
		"SETTINGS":
			main_panel.visible = true
			settings_panel.visible = true
