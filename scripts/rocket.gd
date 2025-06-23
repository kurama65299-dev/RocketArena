extends Node2D

var speed = 1200
var aoe = 3
var direction = null
@onready var raycast: RayCast2D = $RayCast2D

func launch(new_direction):
	direction = new_direction
	
func explosion(collider, coords):
	for x in range(-aoe,aoe+1):
		var next_block = Vector2i(coords.x + x, coords.y)
		collider.set_cell(next_block, -1)
	for y in range(-aoe,aoe+1):
		var next_block =  Vector2i(coords.x, coords.y + y)
		collider.set_cell(next_block, -1)
	
	var count = 0
	var sum = 1
	for x in range(-aoe,aoe+1): #Checks every x row
		if count == aoe:
			sum = -1
		for y in range(-count,count+1): #Checks every y row based on the counter, still in a determinated x row
			var next_block
			next_block =  Vector2i(coords.x + x, coords.y + y) 
			collider.set_cell(next_block, -1)
			next_block =  Vector2i(coords.x + x, coords.y - y)
			collider.set_cell(next_block, -1)
		count += sum #Maintains the aoe counter
	
func _physics_process(delta: float) -> void:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMapLayer:
			var point = raycast.get_collision_point()
			var coords = collider.local_to_map(point)
			explosion(collider, coords)
			queue_free()
	if direction != null:
		global_position += speed * direction * delta
		rotation = direction.angle()


func _on_timer_timeout() -> void:
	queue_free()
