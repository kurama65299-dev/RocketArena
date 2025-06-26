extends Node

const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MAIN_MENU = preload("res://scenes/main_menu.tscn")
var in_game = false
var teams = 0
var players = 1

func start_game():
	in_game = true
	get_tree().change_scene_to_packed(GAME_SCENE)
	
	var world_path = "/root/Game/World"
	while not get_node_or_null(world_path):
		await get_tree().process_frame
	var world = get_node(world_path)
	
	for i in range(players - 2, -1, -1): #Excludes keyboard player and the overall size of the array
		get_node("/root/Game/World").add_player(i)
func end_game():
	in_game = false
	get_tree().change_scene_to_packed(MAIN_MENU)

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	create_inputs()
	
func create_inputs():
	for i in range(0,9):
		var suffix = str(i)
		var submit = "submit"+suffix
		if not InputMap.has_action(submit):
			InputMap.add_action(submit, 0.5)
			var joystick_event = InputEventJoypadButton.new()
			joystick_event.device = i
			joystick_event.button_index = JOY_BUTTON_A
			InputMap.action_add_event(submit, joystick_event)

func _on_joy_connection_changed(device_id, connected):
	if connected:
		players += 1
	else:
		players -= 1
