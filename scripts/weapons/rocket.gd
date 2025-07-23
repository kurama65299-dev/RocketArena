class_name Rocket
extends Node2D

var owner_id = null
var direction: Vector2 = Vector2.ZERO

@export var speed: int = 2000
@export var aoe: int = 6
@export var damage: int = 40
@export var impulse: float = 340

@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_vfx: CPUParticles2D = $ExplosionVFX
@onready var tile_logic: Node = get_node("/root/Game/World/TileLogic")
@onready var impact_area: Area2D = $Explosion
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var explosion_sfx: AudioStreamPlayer = $ExplosionSFX
@onready var trail: CPUParticles2D = $Trail
@onready var world: Node = get_node("/root/Game/World")
@onready var camera_2d: Camera2D = get_node("/root/Game/World/Camera2D")
var is_detonated: bool = false
var type: String = "NORMAL"


func launch(new_direction):
	direction = new_direction.normalized()
	trail.emitting = true
	impact_area.scale = Vector2(aoe,aoe)
	raycast.add_exception(hitbox_collision.get_parent())
	
func impact():
	is_detonated = true
	
	explosion_vfx.emitting = true
	sprite.visible = false
	
	if type == "NORMAL":
		camera_2d.trigger_camera_shake(3.0)
	elif type == "ULTIMATE":
		camera_2d.trigger_camera_shake(30.0)
		
	tile_logic.aoe_damage(global_position, damage, aoe)
	
	var min_pitch = explosion_sfx.pitch_scale / 1.2
	var max_pitch = explosion_sfx.pitch_scale * 1.2
	explosion_sfx.pitch_scale = randf_range(min_pitch, max_pitch)
	explosion_sfx.play()
	
	var collider = raycast.get_collider()
	for collision in impact_area.get_overlapping_bodies():
		if collision.player_id == owner_id:
			rocket_jump(collision)
		else:
			rocket_jump(collision)
			collision.damage(damage, owner_id)
	explosion_effects()
	
	direction = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	if is_detonated:
		return
		
	if direction != Vector2.ZERO: #MOVING
		global_position += (speed * direction) * delta
		
	if raycast.is_colliding(): #HITBOX AND DAMAGE
		var collider = raycast.get_collider()
		if collider is Player and collider.player_id == owner_id:
			return
		if collider.get_parent() is Rocket and collider.get_parent().owner_id == owner_id:
			return
			
		raycast.enabled = false
		impact()

func rocket_jump(player):
	var impulse_pos = global_position
	var target_pos = player.global_position
	var direction = (target_pos - impulse_pos).normalized()
	var total_impulse = direction * impulse
	player.impulse += total_impulse

func explosion_effects():
	hitbox_collision.disabled = true
	trail.emitting = false
	await get_tree().create_timer(trail.lifetime).timeout
	queue_free()
