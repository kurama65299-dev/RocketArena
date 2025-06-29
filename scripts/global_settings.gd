extends Node

@onready var player_manager: GridContainer = $"../PlaySettings/Players/PlayerManager"
const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MAIN_MENU = preload("res://scenes/main_menu.tscn")
var in_game = false
var teams = 0
var map: String = "SpikyBattle"
var time = 900
var teams_enabled = false
var gamemode = "free_for_all"
var players = []

func start_game():
	in_game = true
	get_tree().change_scene_to_packed(GAME_SCENE)
	
	var world_path = "/root/Game/World"
	while not get_node_or_null(world_path):
		await get_tree().process_frame
	var world = get_node(world_path)
	
	var index = 0
	
	for player in players:
		world.add_player(player.Device, player.Name)
func end_game():
	in_game = false
	get_tree().change_scene_to_packed(MAIN_MENU)
	
	var player_names_path = "/root/MainMenu/PlaySettings/Players/PlayerManager"
	
	while not get_node_or_null(player_names_path):
		await get_tree().process_frame
		
	var player_names = get_node(player_names_path)
	
	for player in players:
		var player_name = player_names.get_child(player.Device + 1).get_node("PlayerName")
		player_name.text = player.Name
	players = []
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
