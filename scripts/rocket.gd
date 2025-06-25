extends Node2D

var speed: int = 1400
var aoe: int = 8
var direction: Vector2 = Vector2.ZERO
var damage: int = 50
@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_logic: Node = get_node("/root/Game/World/TileLogic")
@onready var impact_area: Area2D = $Area2D

func launch(new_direction):
	impact_area.scale = Vector2(aoe,aoe)
	animated_sprite.scale = Vector2(aoe/4,aoe/4)
	direction = new_direction
	
func explosion(collider, coords): #DESTRUCTION
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
		if collider is TileMapLayer:
			var point = raycast.get_collision_point()
			var coords = collider.local_to_map(point)
			explosion(collider, coords)
		direction = Vector2.ZERO
		animated_sprite.visible = true
		sprite.visible = false
		for collision in impact_area.get_overlapping_bodies():
			if collision is Player:
				collision.health -= damage
		animated_sprite.play("explosion")
		
	if direction != Vector2.ZERO: #MOVING
		global_position += speed * direction * delta
		rotation = direction.angle()

func _on_timer_timeout() -> void:
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
