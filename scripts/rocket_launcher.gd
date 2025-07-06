extends Node2D

@onready var shoot_point: Marker2D = $ShootPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debris: Node = get_node("/root/Game/World/Debris")
@onready var player: Player = get_parent().get_parent().get_parent()
@onready var strong_rocket_timer: Timer = $StrongRocket
@onready var ultimate: ProgressBar = player.get_node("Ultimate")
@onready var ready_vfx: CPUParticles2D = player.get_node("Ultimate/ReadyVFX")

func _ready():
	ultimate.max_value = strong_rocket_timer.wait_time

func _process(delta: float) -> void:
	ultimate.value = strong_rocket_timer.wait_time - strong_rocket_timer.time_left
	ready_vfx.emitting = ultimate.value == ultimate.max_value

func shoot(direction):
	global_rotation = direction.angle()
	animation_player.play("recoil")
	
	var point = shoot_point.global_position
	
	var rocket
	if strong_rocket_timer.is_stopped():
		rocket = preload("res://scenes/strong_rocket.tscn")
	else:
		rocket = preload("res://scenes/rocket.tscn")
		
	var new_rocket = rocket.instantiate()
	strong_rocket_timer.start()
	
	debris.add_child(new_rocket)
	
	new_rocket.owner_id = player.player_id
	new_rocket.global_position = point
	new_rocket.launch(direction)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
