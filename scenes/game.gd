extends Node

@onready var world: Node = $World

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device_id, connected):
	if connected:
		world.add_player(device_id)
	else:
		world.remove_player(device_id)
