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
	await get_tree().create_timer(1).timeout
	
	var new_player = PLAYER.instantiate()
	new_player.player_id = device_id
	get_node("Players").add_child(new_player)
	
	new_player.player_setup()

func create_custom_inputs(device_id: int):
	var suffix = str(device_id)
	var right = "right" + suffix
	var left = "left" + suffix
	var jump = "jump" + suffix
	var shoot = "shoot" + suffix
	var ultimate = "ultimate" + suffix
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
		
		var joy_event_a = InputEventJoypadButton.new()
		joy_event_a.device = device_id
		joy_event_a.button_index = JOY_BUTTON_A
		InputMap.action_add_event(jump, joy_event_a)
		
		var joy_event_b = InputEventJoypadButton.new()
		joy_event_b.device = device_id
		joy_event_b.button_index = JOY_BUTTON_LEFT_SHOULDER
		InputMap.action_add_event(jump, joy_event_b)
	if not InputMap.has_action(shoot):
		InputMap.add_action(shoot, 0.5)
		
		var joy_event_a = InputEventJoypadButton.new()
		joy_event_a.device = device_id
		joy_event_a.button_index = JOY_BUTTON_B
		InputMap.action_add_event(shoot, joy_event_a)
		
		var joy_event_b = InputEventJoypadButton.new()
		joy_event_b.device = device_id
		joy_event_b.button_index = JOY_BUTTON_RIGHT_SHOULDER
		InputMap.action_add_event(shoot, joy_event_b)
	if not InputMap.has_action(switch_weapon):
		InputMap.add_action(switch_weapon, 0.5)
		
		var joy_event = InputEventJoypadButton.new()
		joy_event.device = device_id
		joy_event.button_index = JOY_BUTTON_X
		InputMap.action_add_event(switch_weapon, joy_event)
	if not InputMap.has_action(ultimate):
		InputMap.add_action(ultimate, 0.5)
		
		var joy_event_a = InputEventJoypadButton.new()
		joy_event_a.device = device_id
		joy_event_a.button_index = JOY_BUTTON_Y
		InputMap.action_add_event(ultimate, joy_event_a)
		
		var joy_event_b = InputEventJoypadMotion.new()
		joy_event_b.device = device_id
		joy_event_b.axis = JOY_AXIS_TRIGGER_RIGHT
		InputMap.action_add_event(ultimate, joy_event_b)

func assign_player_color(device_id: int):
	var player_data
	for id in GlobalSettings.players.keys():
		if id == device_id:
			player_data = GlobalSettings.players[id]
			
	if GlobalSettings.teams_enabled:
		if player_data.Team == 1:
			player_data.Color = player_colors["Red"]
		elif player_data.Team == 2:
			player_data.Color = player_colors["Blue"]
		return
	
	match device_id:
		-1:
			player_data.Color = player_colors["White"]
		0:
			player_data.Color = player_colors["Red"]
		1:
			player_data.Color = player_colors["Blue"]
		2:
			player_data.Color = player_colors["Violet"]
		3:
			player_data.Color = player_colors["Green"]
		_:
			player_data.Color = player_colors["White"]

func add_debris(instance, time):
	instance.reparent(self)
	await get_tree().create_timer(time).timeout
	if is_instance_valid(instance):
		instance.queue_free()
