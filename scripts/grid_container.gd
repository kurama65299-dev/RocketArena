extends GridContainer

var id_list: Dictionary = {}
var charge_per_second: int = 200
var players_ready: Array = []
@onready var start_countdown: Timer = $StartCountdown
@onready var countdown: Label = $"../Countdown"
@onready var start_button: Button = $"../Start"

func _ready():
	var id: int = 0
	for child in get_children():
		if child.name != "Keyboard" and child is Panel:
			id_list[id] = child
			id += 1

func _joystick_detection(delta, submit_id):
	var suffix = str(submit_id)
	var submit = "submit"+suffix
	var ReadyBar = id_list[submit_id].get_node("ReadyBar")
	if Input.is_action_pressed(submit):
		ReadyBar.value += charge_per_second * delta
	else:
		if ReadyBar.value < 100:
			ReadyBar.value = 0
		elif ReadyBar.value >= 100 and !players_ready.has(submit_id):
			GlobalSettings.joystick_players += 1
			players_ready.append(submit_id)

func _keyboard_detection(delta):
	var ReadyBar = get_node("Keyboard/ReadyBar")
	if Input.is_action_pressed("submit"):
		ReadyBar.value += charge_per_second * delta
	else:
		if ReadyBar.value < 100:
			ReadyBar.value = 0
		elif ReadyBar.value >= 100 and !players_ready.has("Keyboard"):
			GlobalSettings.keyboard_player = 1
			players_ready.append("Keyboard")

func _process(delta):
	for id in range(id_list.size() - 1, -1, -1):
		_joystick_detection(delta, id)
	_keyboard_detection(delta)
	
	countdown.text = "Starting in " + str(round(start_countdown.time_left * 10) / 10)

func _on_start_countdown_timeout() -> void:
	GlobalSettings.start_game()


func _on_start_button_down() -> void:
	if start_countdown.is_stopped():
		start_countdown.start()
		countdown.visible = true
		start_button.visible = false
