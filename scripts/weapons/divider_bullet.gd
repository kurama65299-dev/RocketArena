extends Area2D

var owner_id = null
var direction: Vector2 = Vector2.ZERO
@export var damage: int = 7
@export var speed: int = 3000
@onready var tile_logic: Node = get_node("/root/Game/World/TileLogic")
@onready var tile_map: TileMapLayer = get_node("/root/Game/World/TileLogic/TileMapLayer")
@onready var smoke_vfx: CPUParticles2D = $SmokeVFX
@onready var world: Node = get_node("/root/Game/World")

func shot(new_direction: Vector2):
	direction = new_direction.normalized()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO: #MOVING
		global_position += (speed * direction) * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.player_id == owner_id:
			return
		body.damage(damage, owner_id)
	var coords: Vector2i = tile_map.local_to_map(global_position)
	tile_logic.damage_tile(coords, damage)
	smoke_vfx.emitting = true
	world.add_debris(smoke_vfx, 3)
	queue_free()
