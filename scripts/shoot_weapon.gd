extends Node

var weapons: Dictionary = GlobalSettings.weapons

var cooldowns : Dictionary = {
	weapons.ROCKET_LAUNCHER : false,
	weapons.ELIPSER : false,
	weapons.CONSTRUCTION : false
}

@onready var rocket_launcher_timer: Timer = $"../Cooldowns/RocketLauncher"
@onready var weapons_node: Node2D = $"../AnimatedSprite2D/Weapons"

func shoot(player_weapon: int, direction):
	if has_cooldown(player_weapon):
		return
	if player_weapon == weapons.ROCKET_LAUNCHER:
		var weapon = weapons_node.get_node("RocketLauncher")
		weapon.visible = true
		weapon.shoot(direction)
		
		rocket_launcher_timer.start()
		set_cooldown(player_weapon, true)

func _on_rocket_launcher_timeout() -> void:
	set_cooldown(weapons.ROCKET_LAUNCHER, false)

func _on_construction_timeout() -> void:
	set_cooldown(weapons.CONSTRUCTION, false)

func has_cooldown(weapon_num: int):
	if cooldowns[weapon_num] == true:
		return true
	else:
		return false

func set_cooldown(weapon_num: int, value: bool):
	cooldowns[weapon_num] = value
