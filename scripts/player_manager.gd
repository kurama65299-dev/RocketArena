extends GridContainer

var joystick_panels: Array = []
var charge_per_second: int = 340
@onready var start_countdown: Timer = $StartCountdown
@onready var countdown: Label = $"../Countdown"
@onready var start_button: Button = $"../Start"
@onready var play_settings: Panel = $"../.."

func _ready():
	for child in get_children():
		if child.name == "Keyboard" or !child is Panel:
			continue
		joystick_panels.append(child)

func is_player_ready(id):
	var found = false
	for player in GlobalSettings.players:
		if player.Device == id:
			found = true
	return found

func _joystick_detection(delta, submit_id):
	var suffix = str(submit_id)
	var submit = "submit"+suffix
	
	var player_panel = joystick_panels[submit_id]
		
	var ReadyBar = player_panel.get_node("ReadyBar")
	var plr_name = player_panel.get_node("PlayerName").text
	
	if Input.is_action_pressed(submit):
		ReadyBar.value += charge_per_second * delta
		if ReadyBar.value >= 100:
			start_button.visible = true
	else:
		if ReadyBar.value < 100:
			ReadyBar.value = 0
		elif ReadyBar.value >= 100 and not is_player_ready(submit_id):
			GlobalSettings.players.append({"Name": plr_name, "Device": submit_id})

func _keyboard_detection(delta):
	var ReadyBar = get_node("Keyboard/ReadyBar")
	var plr_name = get_node("Keyboard/PlayerName").text
	if Input.is_action_pressed("submit"):
		ReadyBar.value += charge_per_second * delta
		if ReadyBar.value >= 100:
			start_button.visible = true
	else:
		if ReadyBar.value < 100:
			ReadyBar.value = 0
		elif ReadyBar.value >= 100 and not is_player_ready(-1):
			GlobalSettings.players.append({"Device": -1, "Name": plr_name})

func _process(delta):
	if play_settings.visible == false:
		return
	for id in range(joystick_panels.size()-1, -1, -1):
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
