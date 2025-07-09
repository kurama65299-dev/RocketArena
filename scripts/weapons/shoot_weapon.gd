extends Node

const SPLITTER: PackedScene = preload("res://scenes/weapons/splitter.tscn")
const DIVIDER: PackedScene = preload("res://scenes/weapons/divider.tscn")
@onready var player: Player = $".."
@onready var p_weapons_node: Node2D = $"../AnimatedSprite2D/Weapons/Primary"
@onready var s_weapons_node: Node2D = $"../AnimatedSprite2D/Weapons/Secondary"
var weapons: Dictionary = GlobalSettings.weapons

func shoot(player_weapon: int, direction: Vector2, type: String):
	var weapon
	match player_weapon:
		weapons.SPLITTER:
			weapon = p_weapons_node.get_node("Splitter")
		weapons.DIVIDER:
			weapon = p_weapons_node.get_node("Divider")
	if weapon and weapon.has_method("shoot"):
		weapon.shoot(direction, type)

func update_weaponry():
	var primary
	match player.primary_weapon:
		weapons.SPLITTER:
			primary = SPLITTER.instantiate()
		weapons.DIVIDER:
			primary = DIVIDER.instantiate()
			
	var has_weapon: bool = false
	
	for child in p_weapons_node.get_children():
		if child.scene_file_path == primary.scene_file_path:
			has_weapon = true
			
	if has_weapon:
		pass
	else:
		for child in p_weapons_node.get_children():
			child.queue_free()
		p_weapons_node.add_child(primary)
		
	var secondary
	match player.secondary_weapon:
		weapons.CONSTRUCTION:
			pass
	has_weapon = false
	
	for child in s_weapons_node.get_children():
		if child.scene_file_path == secondary.scene_file_path:
			has_weapon = true
			
	if has_weapon:
		pass
	else:
		for child in s_weapons_node.get_children():
			child.queue_free()
		s_weapons_node.add_child(secondary)
	
