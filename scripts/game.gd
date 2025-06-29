extends Node

@onready var end_game: Timer = $EndGame
@onready var label: Label = $EndGame/Label
@onready var scores_box: VBoxContainer = $Scores

func _ready():
	end_game.start(GlobalSettings.time)
	if GlobalSettings.gamemode == "free_for_all":
		free_for_all()
	
func _process(delta):
	timer_ui(delta)
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
		

var seconds_passed = 0

func timer_ui(delta):
	seconds_passed += delta
	if seconds_passed >= 1:
		seconds_passed = 0
		label.text = "Time: " + str(round(end_game.time_left))
	
func _on_end_game_timeout() -> void:
	GlobalSettings.end_game()
	
func _on_menu_button_down() -> void:
	GlobalSettings.end_game()
