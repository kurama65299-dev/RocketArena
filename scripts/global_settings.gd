extends Node

@onready var player_manager: GridContainer = $"../PlaySettings/Players/PlayerManager"
const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MAIN_MENU = preload("res://scenes/main_menu.tscn")
var in_game = false
var teams = 0
var joystick_players: int = 0
var keyboard_player: int = 0
var map: String = "SpikyBattle"

func start_game(player_names):
	in_game = true
	get_tree().change_scene_to_packed(GAME_SCENE)
	
	var world_path = "/root/Game/World"
	while not get_node_or_null(world_path):
		await get_tree().process_frame
	var world = get_node(world_path)
	
	if keyboard_player == 1:
		var plr_name = player_names[0]
		get_node("/root/Game/World").add_player(-1, plr_name)
	player_names.remove_at(0)
	for i in range(joystick_players - 1, -1, -1):
		var plr_name = ""
		plr_name = player_names[i]
		player_names.remove_at(i)
		get_node("/root/Game/World").add_player(i, plr_name)
func end_game():
	in_game = false
	get_tree().change_scene_to_packed(MAIN_MENU)

func _ready():
	create_inputs()
	
func create_inputs():
	for i in range(0,8):
		var suffix = str(i)
		var submit = "submit"+suffix
		if not InputMap.has_action(submit):
			InputMap.add_action(submit, 0.5)
			var joystick_event = InputEventJoypadButton.new()
			joystick_event.device = i
			joystick_event.button_index = JOY_BUTTON_A
			InputMap.action_add_event(submit, joystick_event)
