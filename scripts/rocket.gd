extends Node2D

var owner_id = null
var speed: int = 2000
var aoe: int = 6
var direction: Vector2 = Vector2.ZERO
var damage: int = 40
var impulse: float = 420
@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_logic: Node = get_node("/root/Game/World/TileLogic")
@onready var tile_map: TileMapLayer = get_node("/root/Game/World/TileLogic/TileMapLayer")
@onready var impact_area: Area2D = $Area2D

func launch(new_direction):
	impact_area.scale = Vector2(aoe,aoe)
	animated_sprite.scale = Vector2(aoe/3,aoe/3)
	direction = new_direction
	
func explosion(): #DESTRUCTION
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
	
func _physics_process(delta: float) -> void:
	if raycast.is_colliding(): #HITBOX AND DAMAGE
		raycast.enabled = false
		
		var collider = raycast.get_collider()
		explosion()
		animated_sprite.visible = true
		sprite.visible = false
		
		for collision in impact_area.get_overlapping_bodies():
			if collision is Player and collision.player_id != owner_id:
				collision.health -= damage
			elif collision is Player and collision.player_id == owner_id:
				var impulse_pos = global_position
				var target_pos = collision.global_position
				var direction = (target_pos - impulse_pos).normalized()
				var total_impulse = direction * impulse
				collision.impulse += total_impulse
		animated_sprite.play("explosion")
		direction = Vector2.ZERO
		
	if direction != Vector2.ZERO: #MOVING
		global_position += (speed * direction) * delta
		rotation = direction.angle()

func _on_timer_timeout() -> void:
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
