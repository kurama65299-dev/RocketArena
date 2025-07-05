extends Node

var cooldowns : Dictionary = {
	"rocket_launcher" : true,
	"construction" : true
}

@onready var rocket_launcher_timer: Timer = $"../Cooldowns/RocketLauncher"
@onready var weapons: Node2D = $"../AnimatedSprite2D/Weapons"

func shoot(player_weapon, direction):
	if cooldowns[player_weapon] == false:
		return
	if player_weapon == "rocket_launcher":
		var weapon = weapons.get_node("RocketLauncher")
		weapon.visible = true
		weapon.shoot(direction)
		cooldowns["rocket_launcher"] = false
		rocket_launcher_timer.start()

func _on_rocket_launcher_timeout() -> void:
	cooldowns["rocket_launcher"] = true

func _on_construction_timeout() -> void:
	cooldowns["construction"] = true
