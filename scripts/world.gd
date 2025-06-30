extends Node

const PLAYER: PackedScene = preload("res://scenes/player.tscn")
@onready var tile_logic: Node = $TileLogic
var player_colors: Dictionary = {
	"Red": Color("E55F2A"),
	"Green": Color("6FCF26"),
	"Blue": Color("1C64D9"),
	"Violet": Color("a59eff"),
}

func add_player(device_id, plr_name):
	while tile_logic.tile_map == null or not tile_logic.tile_map.is_inside_tree():
		await get_tree().process_frame
	respawn(device_id)
	create_custom_inputs(device_id)

func respawn(device_id):
	var new_player = PLAYER.instantiate()
	new_player.player_id = device_id
	get_node("Players").add_child(new_player)
	color_player(new_player, device_id)
	
	var name_label = new_player.get_node("PlayerName")
	for player in GlobalSettings.players:
		if player.Device == device_id:
			name_label.text = player.Name
	
	var tile_map = tile_logic.tile_map
	
	var spawn_points = tile_map.get_node("SpawnPoints")
	var random = randi_range(0, spawn_points.get_child_count())
	new_player.global_position = spawn_points.get_child(random).global_position

func create_custom_inputs(device_id: int):
	var suffix = str(device_id)
	var right = "right" + suffix
	var left = "left" + suffix
	var jump = "jump" + suffix
	var shoot = "shoot" + suffix
	var aim = "aim" + suffix
	
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
		joy_event.button_index = JOY_BUTTON_A
		InputMap.action_add_event(jump, joy_event)
	if not InputMap.has_action(shoot):
		InputMap.add_action(shoot, 0.5)
		var joy_event = InputEventJoypadButton.new()
		joy_event.device = device_id
		joy_event.button_index = JOY_BUTTON_B
		InputMap.action_add_event(shoot, joy_event)

func color_player(player, device_id: int):
	if device_id == -1:
		pass
	elif device_id == 0:
		player.get_node("PlayerName").modulate = player_colors["Red"]
		player.get_node("AnimatedSprite2D").self_modulate = player_colors["Red"]
		player.get_node("AimArrow").modulate = player_colors["Red"]
	elif device_id == 1:
		player.get_node("PlayerName").modulate = player_colors["Blue"]
		player.get_node("AnimatedSprite2D").self_modulate = player_colors["Blue"]
		player.get_node("AimArrow").modulate = player_colors["Blue"]
	elif device_id == 2:
		player.get_node("PlayerName").modulate = player_colors["Violet"]
		player.get_node("AnimatedSprite2D").self_modulate = player_colors["Violet"]
		player.get_node("AimArrow").modulate = player_colors["Violet"]
	elif device_id == 2:
		player.get_node("PlayerName").modulate = player_colors["Green"]
		player.get_node("AnimatedSprite2D").self_modulate = player_colors["Green"]
		player.get_node("AimArrow").modulate = player_colors["Green"]
