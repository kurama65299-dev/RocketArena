extends Node2D

@onready var shoot_point: Marker2D = $ShootPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func shoot():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	animation_player.play("shoot")
	
	var point = shoot_point.global_position
	var rocket = preload("res://scenes/rocket.tscn")
	var new_rocket = rocket.instantiate()
	
	get_tree().get_root().add_child(new_rocket)
	
	var shoot_direction = (mouse_pos - point).normalized()
	new_rocket.global_position = point
	new_rocket.launch(shoot_direction)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
