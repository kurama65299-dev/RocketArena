extends Node

var cooldowns : Dictionary = {
	"rocket_launcher" : true
}

@onready var rocket_launcher_timer: Timer = $"../Cooldowns/RocketLauncher"
@onready var weapons: Node2D = $"../AnimatedSprite2D/Weapons"

func shoot(player_weapon, direction):
	if cooldowns[player_weapon] == false:
		return
	if player_weapon == "rocket_launcher":
		var weapon = preload("res://scenes/rocket_launcher.tscn")
		var new_weapon = weapon.instantiate()
		weapons.add_child(new_weapon)
		new_weapon.position = Vector2.ZERO
		new_weapon.shoot(direction)
		cooldowns["rocket_launcher"] = false
		rocket_launcher_timer.start()

func _on_rocket_launcher_timeout() -> void:
	cooldowns["rocket_launcher"] = true
