extends VBoxContainer

@onready var gamemode_option: OptionButton = $Gamemode/OptionButton
@onready var map_option: OptionButton = $Map/OptionButton
@onready var time_value: SpinBox = $Time/SpinBox

func _ready():
	time_value.value = GlobalSettings.time
	map_option.select(GlobalSettings.map)
	gamemode_option.select(GlobalSettings.gamemode)
func update_options():
	GlobalSettings.time = time_value.value
	GlobalSettings.map = map_option.selected
	GlobalSettings.gamemode = gamemode_option.selected
