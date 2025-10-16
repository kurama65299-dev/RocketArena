extends Node

var GAME_SCENE: PackedScene = load("res://scenes/game.tscn")
var MAIN_MENU: PackedScene = load("res://scenes/main_menu.tscn")
var time: int = 300

enum weapons {SPLITTER, DIVIDER, CONSTRUCTION}

enum maps {SPIKY_BATTLE,DESCENDING_WAR,ISLAMIC_HELL,IRON_VALLEY,JUMPY_CONFRONTATION,SEDIMENT_ERUPTION}
var map: int = maps.SPIKY_BATTLE

enum gamemodes {FREE_FOR_ALL,KEEP_THE_BRIEFCASE}
var gamemode: int = gamemodes.FREE_FOR_ALL

var teams_enabled: bool = false
var players = {}

func start_game():
	get_tree().change_scene_to_packed(GAME_SCENE)
	
	var world_path = "/root/Game/World"
	while not get_node_or_null(world_path):
		await get_tree().process_frame
	var world = get_node(world_path)
	
	for id in players.keys():
		world.add_player(id)
		
func end_game():
	get_tree().change_scene_to_packed(MAIN_MENU)
