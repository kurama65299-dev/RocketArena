extends Node

@onready var end_game: Timer = $EndGame
@onready var label: Label = $EndGame/Label

func _ready():
	end_game.start(GlobalSettings.time)
	
func _process(delta):
	timer_ui(delta)

var seconds_passed = 0
func timer_ui(delta):
	seconds_passed += delta
	if seconds_passed >= 1:
		seconds_passed = 0
		label.text = "Time: " + str(round(end_game.time_left))
	
func _on_end_game_timeout() -> void:
	GlobalSettings.end_game()
