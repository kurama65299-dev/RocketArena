extends Node

const PLAYER: PackedScene = preload("res://scenes/player.tscn")
@onready var tile_logic: Node = $TileLogic
var player_colors: Dictionary = {
	"White": Color("FFFFFF"),
	"Red": Color("ff0000"),
	"Green": Color("6FCF26"),
	"Blue": Color("0800ff"),
	"Violet": Color("a59eff"),
}

func add_player(device_id: int):
	while tile_logic.tile_map == null or not tile_logic.tile_map.is_inside_tree():
		await get_tree().process_frame
	assign_player_color(device_id)
	respawn(device_id)
	create_custom_inputs(device_id)

func respawn(device_id: int):
	await get_tree().create_timer(0.1).timeout
	var player_data
	for player_index in GlobalSettings.players:
		if player_index.Device == device_id:
			player_data = player_index
			player_index = player_data
	var new_player = PLAYER.instantiate()
	get_node("Players").add_child(new_player)
	
	new_player.get_node("PlayerName").modulate = player_data.Color
	new_player.get_node("AnimatedSprite2D").self_modulate = player_data.Color
	new_player.get_node("AimArrow").modulate = player_data.Color
	
	new_player.player_id = device_id
	var name_label = new_player.get_node("PlayerName")
	for player in GlobalSettings.players:
		if player.Device == device_id:
			name_label.text = player.Name
			new_player.name = player.Name
			new_player.team = player.Team
	
	var tile_map = tile_logic.tile_map
	
	var spawn_points = tile_map.get_node("SpawnPoints")
	var random = randi_range(0, spawn_points.get_child_count()-1)
	new_player.global_position = spawn_points.get_child(random).global_position

func create_custom_inputs(device_id: int):
	var suffix = str(device_id)
	var right = "right" + suffix
	var left = "left" + suffix
	var jump = "jump" + suffix
	var shoot = "shoot" + suffix
	var switch_weapon = "switch_weapon" + suffix
	
	if not InputMap.has_action(right):
		InputMap.add_action(right, 0.5)
		var joy_event = InputEventJoypadMotion.new()
		joy_event.device = device_id
		joy_event.axis = JOY_AXIS_LEFT_X
		joy_event.axis_value = 1
		InputMap.action_add_event(right, joy_event)
	if not InputMap.has_action(left):
		InputMap.add_action(left, 0.5)
		var joy_event = InputEventJoypadMotion.new()
		joy_event.device = device_id
		joy_event.axis = JOY_AXIS_LEFT_X
		joy_event.axis_value = -1
		InputMap.action_add_event(left, joy_event)
	if not InputMap.has_action(jump):
		InputMap.add_action(jump, 0.5)
		var joy_event = InputEventJoypadButton.new()
		joy_event.device = device_id
		joy_event.button_index = JOY_BUTTON_LEFT_SHOULDER
		InputMap.action_add_event(jump, joy_event)
	if not InputMap.has_action(shoot):
		InputMap.add_action(shoot, 0.5)
		var joy_event = InputEventJoypadButton.new()
		joy_event.device = device_id
		joy_event.button_index = JOY_BUTTON_RIGHT_SHOULDER
		InputMap.action_add_event(shoot, joy_event)
	if not InputMap.has_action(switch_weapon):
		InputMap.add_action(switch_weapon, 0.5)
		var joy_event = InputEventJoypadButton.new()
		joy_event.device = device_id
		joy_event.button_index = JOY_BUTTON_X
		InputMap.action_add_event(switch_weapon, joy_event)

func assign_player_color(device_id: int):
	var player_data
	for player_index in GlobalSettings.players:
		if player_index.Device == device_id:
			player_data = player_index
			
	if GlobalSettings.teams_enabled:
		if player_data.Team == 1:
			player_data.Color = player_colors["Red"]
		elif player_data.Team == 2:
			player_data.Color = player_colors["Blue"]
		return
		
	if device_id == -1:
		player_data.Color = player_colors["White"]
	elif device_id == 0:
		player_data.Color = player_colors["Red"]
	elif device_id == 1:
		player_data.Color = player_colors["Blue"]
	elif device_id == 2:
		player_data.Color = player_colors["Violet"]
	elif device_id == 3:
		player_data.Color = player_colors["Green"]
