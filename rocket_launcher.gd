extends Node2D

@onready var shoot_point: Marker2D = $ShootPoint

func shoot():
	var point = shoot_point.global_position
	var mouse_pos = get_global_mouse_position()
	var rocket = preload("res://scenes/rocket.tscn")
	var new_rocket = rocket.instantiate()
	get_tree().get_root().add_child(new_rocket)
	new_rocket.global_position = point
	var direction = (mouse_pos - point).normalized()
	new_rocket.launch(direction)
	queue_free()
