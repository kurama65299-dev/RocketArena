extends GridContainer

const PLAYER_PANEL = preload("res://scenes/player_info.tscn")
var players_ready: Dictionary = {}
@onready var options: VBoxContainer = $"../Options"

func ready():
	for id in GlobalSettings.players.keys():
		create_panel(id)
	GlobalSettings.players = {}

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if !event.pressed or event.button_index != JOY_BUTTON_A:
			return
			
		if players_ready.has(event.device):
			delete_panel(event.device)
			return
		else:
			players_ready[event.device] = {}
			create_panel(event.device)
	if event is InputEventKey:
		if !event.pressed or event.keycode != KEY_ENTER:
			return
			
		if players_ready.has(-1):
			delete_panel(-1)
			return
		else:
			players_ready[-1] = {}
			create_panel(-1)
		
func create_panel(device_id: int):
	var new_panel = PLAYER_PANEL.instantiate()
	add_child(new_panel)
	new_panel.device_id = device_id
	players_ready[device_id]["Panel"] = new_panel

func delete_panel(device_id: int):
	var panel = players_ready[device_id]["Panel"]
	remove_child(panel)
	players_ready.erase(device_id)

func _on_start_button_down() -> void:
	options.update_options()
	
	var players = GlobalSettings.players
	
	for id in players_ready.keys():
		var player = players_ready[id]
		var info = player.Panel.get_player_info()
		GlobalSettings.players[id] = info
	
	GlobalSettings.start_game()
