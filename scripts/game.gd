extends Node

@onready var end_game_timer: Timer = $EndGame
@onready var time_text: Label = $TimeText
@onready var scores_box: VBoxContainer = $Scores
@onready var return_to_menu: Timer = $EndScreen/ReturnToMenu
@onready var end_screen: Panel = $EndScreen
@onready var killfeed_box: VBoxContainer = $Killfeed
@onready var team_bars: VBoxContainer = $TeamBars
var is_game_ended = false
var teams = {
	"Team1": 0,
	"Team2": 0
}

func _ready():
	end_game_timer.start(GlobalSettings.time)
	timer_ui()
	if GlobalSettings.gamemode == "free_for_all":
		free_for_all()
	if GlobalSettings.gamemode == "keep_the_briefcase":
		keep_the_briefcase()
	
func _process(delta):
	if GlobalSettings.gamemode == "free_for_all":
		update_player_score()
	elif GlobalSettings.gamemode == "keep_the_briefcase":
		update_team_score()
	
func update_player_score():
	var index = 0
	for label in scores_box.get_children():
		if label.name != "ScoreText":
			var player = GlobalSettings.players[index]
			label.text = player.Name + ": " + str(player.Score)
			index += 1

func update_team_score():
	var team_bar1 = team_bars.get_node("Bars/Team1")
	var team_bar2 = team_bars.get_node("Bars/Team2")
	team_bar1.value = teams[team_bar1.name]
	team_bar2.value = teams[team_bar2.name]

func timer_ui():
	time_text.text = "Time: " + str(round(end_game_timer.time_left))
	while !end_game_timer.is_stopped():
		await get_tree().create_timer(1.0).timeout
		time_text.text = "Time: " + str(round(end_game_timer.time_left))
		
	game_ended()
	
func _on_menu_button_down() -> void:
	GlobalSettings.end_game()

func _on_return_to_menu_timeout() -> void:
	GlobalSettings.end_game()
	
func killfeed(killer_name: String, killed_name: String):
	var killer_color: Color
	var killed_color: Color
	
	for player_index in GlobalSettings.players:
		if player_index.Name == killer_name:
			killer_color = player_index.Color
		elif player_index.Name == killed_name:
			killed_color = player_index.Color
			
	var placeholder = killfeed_box.get_node("Placeholder")
	var new_label = placeholder.duplicate()
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
	GlobalSettings.teams_enabled = true
	team_bars.visible = true
	var team1 = team_bars.get_node("Bars/Team1")
	var team2 = team_bars.get_node("Bars/Team2")
	team1.value = 0
	team2.value = 0

func free_for_all():
	var scores = []
	scores_box.visible = true
	for player in GlobalSettings.players:
		player.Score = 0
		var text = scores_box.get_node("ScoreText").duplicate()
		scores_box.add_child(text)
		text.text = player.Name + ": " + str(player.Score)
		text.name = "PlayerScore"
		
func on_player_death(killed_id, killer_id):
	var killer
	var killed
	for player in GlobalSettings.players:
		if player.Device == killer_id:
			killer = player
		if player.Device == killed_id:
			killed = player
	
	killfeed(killer.Name, killed.Name)
	if GlobalSettings.gamemode == "free_for_all":
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
	
	if GlobalSettings.gamemode == "free_for_all":
		var highest_score = -1
		for player in GlobalSettings.players:
			if player.Score > highest_score:
				winner = player
				highest_score = player.Score
		end_screen.visible = true
		end_screen.get_node("WinnerLabel").text = "¡Winner is " + winner.Name + "!"
		end_screen.get_node("Score").text = "Total score: " + str(winner.Score)
	elif GlobalSettings.gamemode == "keep_the_briefcase":
		if teams["Team1"] > teams["Team2"]:
			winner = "Team1"
		else:
			winner = "Team2"
		end_screen.visible = true
		end_screen.get_node("WinnerLabel").text = "¡Winner is " + winner + "!"
		end_screen.get_node("Score").text = "Total score: " + str(teams[winner])
		
	return_to_menu.start()
