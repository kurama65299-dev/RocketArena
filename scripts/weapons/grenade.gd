extends RigidBody2D

var aoe: float = 10
var throw_strength: int = 1700
var owner_id = null
var direction: Vector2 = Vector2.ZERO
var damage: int = 50
var impulse: int = 600
@onready var impact_area: Area2D = $ImpactArea
@onready var explosion_timer: Timer = $Explosion
@onready var explosion_vfx: CPUParticles2D = $ExplosionVFX
@onready var explosion_sfx: AudioStreamPlayer = $ExplosionSFX
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var tile_map: TileMapLayer = get_node("/root/Game/World/TileLogic/TileMapLayer")
@onready var tile_logic: Node = get_node("/root/Game/World/TileLogic")

func environment_damage(): #DESTRUCTION
	var coords: Vector2i = tile_map.local_to_map(global_position)
	var count: int = 0
	var sum: int = 1
	for x in range(-aoe,aoe+1): #Checks every x row
		if count == aoe:
			sum = -1
		for z in range(-count,count+1): #Checks every y row based on the counter, still in a determinated x row
			var next_block
			next_block =  Vector2i(coords.x + x, coords.y + z)
			tile_logic.damage_tile(next_block, damage)
		count += sum #Maintains the aoe counter

func throw(new_direction: Vector2):
	impact_area.scale = Vector2(aoe,aoe)
	explosion_timer.start()
	direction = new_direction.normalized()
	linear_velocity = throw_strength * direction

func _on_explosion_timeout() -> void:
	environment_damage()
	sprite_2d.visible = false
	explosion_vfx.emitting = true
	explosion_sfx.pitch_scale = randf_range(1,1.5)
	explosion_sfx.play()
	
	for body in impact_area.get_overlapping_bodies():
		if body is Player:
			rocket_jump(body)
			if body.player_id == owner_id:
				continue
			body.damage(damage, owner_id)
	
	var time = explosion_vfx.lifetime * explosion_vfx.speed_scale
	await get_tree().create_timer(time).timeout
	queue_free()

func rocket_jump(player):
	var impulse_pos = global_position
	var target_pos = player.global_position
	var direction = (target_pos - impulse_pos).normalized()
	var total_impulse = direction * impulse
	player.impulse += total_impulse
