extends Node

@onready var end_game: Timer = $EndGame
@onready var time_text: Label = $TimeText
@onready var scores_box: VBoxContainer = $Scores
@onready var return_to_menu: Timer = $EndScreen/ReturnToMenu
@onready var end_screen: Panel = $EndScreen
@onready var killfeed_box: VBoxContainer = $Killfeed

func _ready():
	end_game.start(GlobalSettings.time)
	end_game_timer()
	if GlobalSettings.gamemode == "free_for_all":
		free_for_all()
	if GlobalSettings.gamemode == "keep_the_briefcase":
		keep_the_briefcase()
	
func _process(delta):
	update_player_score()
	
func free_for_all():
	var scores = []
	scores_box.visible = true
	for player in GlobalSettings.players:
		player.Score = 0
		var text = scores_box.get_node("ScoreText").duplicate()
		scores_box.add_child(text)
		text.text = player.Name + ": " + str(player.Score)
		text.name = "PlayerScore"
		
func update_player_score():
	var index = 0
	for label in scores_box.get_children():
		if label.name != "ScoreText":
			var player = GlobalSettings.players[index]
			label.text = player.Name + ": " + str(player.Score)
			index += 1

func keep_the_briefcase():
	GlobalSettings.teams_enabled = true

func end_game_timer():
	while !end_game.is_stopped():
		await get_tree().create_timer(1.0).timeout
		time_text.text = "Time: " + str(round(end_game.time_left))
		
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
		return_to_menu.start()
	
	
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
