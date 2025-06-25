extends Node2D

@onready var shoot_point: Marker2D = $ShootPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debris: Node = get_node("/root/Game/World/Debris")

func shoot(direction):
	global_rotation = direction.angle()
	animation_player.play("recoil")
	
	var point = shoot_point.global_position
	var rocket = preload("res://scenes/rocket.tscn")
	var new_rocket = rocket.instantiate()
	
	debris.add_child(new_rocket)
	
	new_rocket.global_position = point
	new_rocket.launch(direction)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
