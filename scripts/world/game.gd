extends Node

const BRIEFCASE_INSTANCE = preload("res://scenes/briefcase.tscn")
@onready var world: Node = $World
@onready var end_game_timer: Timer = $EndGame

@onready var time_value: Label = $UI/Time/Value
@onready var scores_box: VBoxContainer = $UI/Scores
@onready var return_to_menu: Timer = $UI/EndScreen/ReturnToMenu
@onready var end_screen: Panel = $UI/EndScreen
@onready var killfeed_box: VBoxContainer = $UI/Killfeed
@onready var team_bars: VBoxContainer = $UI/TeamBars

var is_game_ended = false

var teams = {
	"Team1": 0,
	"Team2": 0
}

var gamemodes: Dictionary = GlobalSettings.gamemodes

func _ready():
	end_game_timer.start(GlobalSettings.time)
	timer_ui()
	if GlobalSettings.gamemode == gamemodes.FREE_FOR_ALL:
		free_for_all()
	if GlobalSettings.gamemode == gamemodes.KEEP_THE_BRIEFCASE:
		keep_the_briefcase()
	
func _process(delta):
	if GlobalSettings.gamemode == gamemodes.FREE_FOR_ALL:
		update_player_score()
	elif GlobalSettings.gamemode == gamemodes.KEEP_THE_BRIEFCASE:
		update_team_score()
	
func update_player_score():
	for id in GlobalSettings.players.keys():
		var player = GlobalSettings.players[id]
		var score_label = player.ScoreLabel
		score_label.text = player.Name + ": " + str(player.Score)

func update_team_score():
	var team_bar1 = team_bars.get_node("Bars/Team1")
	var team_bar2 = team_bars.get_node("Bars/Team2")
	team_bar1.value = teams[team_bar1.name]
	team_bar2.value = teams[team_bar2.name]

func timer_ui():
	time_value.text = str(round(end_game_timer.time_left))
	while !end_game_timer.is_stopped():
		await get_tree().create_timer(1.0).timeout
		time_value.text = str(round(end_game_timer.time_left))
		
	game_ended()
	
func _on_menu_button_down() -> void:
	GlobalSettings.end_game()

func _on_return_to_menu_timeout() -> void:
	GlobalSettings.end_game()
	
func killfeed(killer_name: String, killed_name: String):
	var killer_color: Color
	var killed_color: Color
	
	for id in GlobalSettings.players.keys():
		var player = GlobalSettings.players[id]
		if player.Name == killer_name:
			killer_color = player.Color
		elif player.Name == killed_name:
			killed_color = player.Color
			
	var placeholder = killfeed_box.get_node("Placeholder")
	var new_label = placeholder.duplicate()
	new_label.get_node("mid_text").text = tr("killed").to_lower()
	killfeed_box.add_child(new_label)
	new_label.visible = true
	
	var killer_label = new_label.get_node("killer")
	killer_label.text = killer_name
	killer_label.add_theme_color_override("font_color", killer_color)
	
	var killed_label = new_label.get_node("killed")
	killed_label.text = killed_name
	killed_label.add_theme_color_override("font_color", killed_color)
	
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(new_label):
		new_label.queue_free()

func keep_the_briefcase():
	var new_briefcase = BRIEFCASE_INSTANCE.instantiate()
	new_briefcase.global_position = Vector2(0,-992.0)
	add_child(new_briefcase)
	
	GlobalSettings.teams_enabled = true
	team_bars.visible = true
	var team1 = team_bars.get_node("Bars/Team1")
	var team2 = team_bars.get_node("Bars/Team2")
	team1.value = 0
	team2.value = 0

func free_for_all():
	scores_box.visible = true
	for id in GlobalSettings.players.keys():
		var player = GlobalSettings.players[id]
		
		var score_label = scores_box.get_node("ScoreText").duplicate()
		scores_box.add_child(score_label)
		score_label.text = player.Name + ": " + str(player.Score)
		score_label.name = "PlayerScore"
		
		player["ScoreLabel"] = score_label
		
func on_player_death(killed_id, killer_id):
	var killer
	var killed
	for id in GlobalSettings.players.keys():
		if id == killer_id:
			killer = GlobalSettings.players[id]
		if id == killed_id:
			killed = GlobalSettings.players[id]
	
	killfeed(killer.Name, killed.Name)
	if GlobalSettings.gamemode == gamemodes.FREE_FOR_ALL:
		killer.Score += 1

func kept_briefcase(team_num: int):
	var key = "Team" + str(team_num)
	teams[key] += 1
	if teams[key] >= 100:
		game_ended()

func game_ended():
	if is_game_ended:
		return
	is_game_ended = true
	
	var winner = null
	var winner_label = end_screen.get_node("WinnerLabel")
	
	if GlobalSettings.gamemode == gamemodes.FREE_FOR_ALL:
		var highest_score = -1
		for id in GlobalSettings.players.keys():
			var player = GlobalSettings.players[id]
			if player.Score > highest_score:
				winner = player
				highest_score = player.Score
		end_screen.visible = true
		winner_label.text = "¡Winner is " + winner.Name + "!"
		end_screen.get_node("Score").text = "Total score: " + str(winner.Score)
	elif GlobalSettings.gamemode == gamemodes.KEEP_THE_BRIEFCASE:
		if teams["Team1"] > teams["Team2"]:
			winner = "Team1"
			winner_label.text = "¡Winner is Red Team!"
			winner_label.add_theme_color_override("font_color", world.player_colors["Red"])
		else:
			winner = "Team2"
			winner_label.text = "¡Winner is Blue Team!"
			winner_label.add_theme_color_override("font_color", world.player_colors["Blue"])
		end_screen.visible = true
		end_screen.get_node("Score").text = "Total score: " + str(teams[winner])
		
	return_to_menu.start()
