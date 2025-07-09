extends Node2D

@onready var shoot_point: Marker2D = $ShootPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debris: Node = get_node("/root/Game/World/Debris")
@onready var player: Player = get_parent().get_parent().get_parent().get_parent()
@onready var strong_rocket_timer: Timer = $StrongRocket
@onready var normal_timer: Timer = $NormalRocket
@onready var ultimate_bar: ProgressBar = player.get_node("Ultimate")
@onready var ready_vfx: CPUParticles2D = player.get_node("Ultimate/ReadyVFX")

func _ready():
	visible = false
	ultimate_bar.max_value = strong_rocket_timer.wait_time
func _process(delta: float) -> void:
	ultimate_bar.value = strong_rocket_timer.wait_time - strong_rocket_timer.time_left
	ready_vfx.emitting = ultimate_bar.value == ultimate_bar.max_value

func shoot(direction, type):
	var rocket
	if strong_rocket_timer.is_stopped() and type == "ULTIMATE":
		rocket = preload("res://scenes/weapons/strong_rocket.tscn")
		strong_rocket_timer.start()
	elif normal_timer.is_stopped() and type == "NORMAL":
		rocket = preload("res://scenes/weapons/rocket.tscn")
		normal_timer.start()
	else:
		return
	
	visible = true
	global_rotation = direction.angle()
	animation_player.play("recoil")
	
	var point = shoot_point.global_position
	
	var new_rocket = rocket.instantiate()
	debris.add_child(new_rocket)
	new_rocket.owner_id = player.player_id
	new_rocket.global_position = point
	new_rocket.global_rotation = direction.angle()
	new_rocket.launch(direction)
	
func _on_animation_player_animation_finished() -> void:
	visible = false
