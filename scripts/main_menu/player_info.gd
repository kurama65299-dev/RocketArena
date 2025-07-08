extends Panel

var device_id = null
var weapons: Dictionary = GlobalSettings.weapons
@onready var name_label: LineEdit = $Name
@onready var primary_weapon_option: OptionButton = $PrimaryWeapon
@onready var secondary_weapon_option: OptionButton = $SecondaryWeapon
@onready var team_option: OptionButton = $Label/Team

func _ready():
	while device_id == null:
		await get_tree().process_frame
		
	var players = GlobalSettings.players
	if players.has(device_id):
		var player_info = players[device_id]
		set_weapons_options(player_info)
		name_label.text = player_info.Name
		match player_info.Team:
			1:		
				team_option.select(0)
			2:
				team_option.select(1)
		
func get_player_info() -> Dictionary:
	var selected_weapons = get_weapons_options()
	return {
		"Name": name_label.text,
		"Team": int(team_option.get_item_text(team_option.selected)),
		"PrimaryWeapon": selected_weapons[0],
		"SecondaryWeapon": selected_weapons[1],
		"Score": 0,
	}

func get_weapons_options() -> Array:
	var primary_weapon
	match primary_weapon_option.selected:
		0:
			primary_weapon = weapons.SPLITTER
		1:
			primary_weapon = weapons.DIVIDER
		_:
			primary_weapon = weapons.SPLITTER
			
	var secondary_weapon
	match secondary_weapon_option.selected:
		0:
			secondary_weapon = weapons.CONSTRUCTION
		_:
			primary_weapon = weapons.CONSTRUCTION
			
	return [primary_weapon, secondary_weapon]

func set_weapons_options(player_info: Dictionary):
	var primary_weapon: int
	match player_info.PrimaryWeapon:
		weapons.SPLITTER:
			primary_weapon = 0
		weapons.DIVIDER:
			primary_weapon = 1
		_:
			primary_weapon = 0
	primary_weapon_option.select(primary_weapon)
	
	var secondary_weapon: int
	match player_info.SecondaryWeapon:
		weapons.CONSTRUCTION:
			secondary_weapon = 0
		_:
			secondary_weapon = 0
	secondary_weapon_option.select(secondary_weapon)
