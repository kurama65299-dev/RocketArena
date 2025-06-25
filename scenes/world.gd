extends Node

var devices_id: Array= []
const PLAYER: PackedScene = preload("res://scenes/player.tscn")
var player_colors: Dictionary = {
	"Red": Color.RED,
	"Green": Color.GREEN,
	"Blue": Color.BLUE,
}

func add_player(device_id):
	var new_player = PLAYER.instantiate()
	new_player.player_id = device_id
	new_player.name = "Player" + str(device_id)
	get_node("Players").add_child(new_player)
	devices_id.append(new_player)
	color_player(new_player, device_id)
	create_custom_inputs(device_id)
	print("Added ID: ", device_id)
	print("Players: ", devices_id)
	
func remove_player(device_id):
	for i in range(devices_id.size() - 1, -1, -1):
		var player = devices_id[i]
		if player.player_index == device_id:
			player.queue_free()
			devices_id.remove_at(i)
			print("Removed ID: ", device_id)
			print("Players: ", devices_id)

func respawn(device_id):
	var new_player = PLAYER.instantiate()
	new_player.player_id = device_id
	new_player.name = "Player" + str(device_id)
	get_node("Players").add_child(new_player)
	color_player(new_player, device_id)
	print("Added ID: ", device_id)
	print("Players: ", devices_id)

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
	if device_id == 0:
		player.get_node("AnimatedSprite2D").modulate = player_colors["Red"]
	elif device_id == 1:
		player.get_node("AnimatedSprite2D").modulate = player_colors["Green"]
	elif device_id == 2:
		player.get_node("AnimatedSprite2D").modulate = player_colors["Blue"]
