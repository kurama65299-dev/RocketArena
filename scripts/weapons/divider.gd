extends Node2D

const BULLET = preload("res://scenes/weapons/divider_bullet.tscn")
const GRENADE = preload("res://scenes/weapons/grenade.tscn")
@onready var shoot_point: Marker2D = $ShootPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debris: Node = get_node("/root/Game/World/Debris")
@onready var player: Player = get_parent().get_parent().get_parent().get_parent()
@onready var grenade_timer: Timer = $Grenade
@onready var normal_timer: Timer = $Bullet
@onready var ultimate_bar: ProgressBar = player.get_node("Ultimate")
@onready var ready_vfx: CPUParticles2D = player.get_node("Ultimate/ReadyVFX")
@onready var camera_2d: Camera2D = get_node("/root/Game/World/Camera2D")

func _ready():
	visible = false
	ultimate_bar.max_value = grenade_timer.wait_time
func _process(delta: float) -> void:
	ultimate_bar.value = grenade_timer.wait_time - grenade_timer.time_left
	ready_vfx.emitting = ultimate_bar.value == ultimate_bar.max_value

func shoot(direction: Vector2, type: String):
	if grenade_timer.is_stopped() and type == "ULTIMATE":
		grenade(direction)
		grenade_timer.start()
	elif normal_timer.is_stopped() and type == "NORMAL":
		normal_shoot(direction)
		normal_timer.start()
	else:
		return
	
func normal_shoot(direction: Vector2):
	camera_2d.trigger_camera_shake(0.2)
	visible = true
	global_rotation = direction.angle()
	animation_player.stop()
	animation_player.play("recoil")
	var point = shoot_point.global_position
	
	var new_bullet = BULLET.instantiate()
	debris.add_child(new_bullet)
	new_bullet.owner_id = player.player_id
	new_bullet.global_position = point
	new_bullet.global_rotation = direction.angle()
	new_bullet.shot(direction)
	await animation_player.animation_finished
	
func grenade(direction: Vector2):
	var new_grenade = GRENADE.instantiate()
	debris.add_child(new_grenade)
	new_grenade.owner_id = player.player_id
	new_grenade.global_position = global_position
	new_grenade.global_rotation = direction.angle()
	new_grenade.throw(direction)
	
func _on_animation_player_animation_finished() -> void:
	visible = false
