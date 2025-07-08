extends Node

var weapons: Dictionary = GlobalSettings.weapons
@onready var weapons_node: Node2D = $"../AnimatedSprite2D/Weapons"

func shoot(player_weapon: int, direction: Vector2, type: String):
	if player_weapon == weapons.SPLITTER:
		var weapon = weapons_node.get_node("Splitter")
		if weapon.has_method("shoot"):
			weapon.shoot(direction, type)
