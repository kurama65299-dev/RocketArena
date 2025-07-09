extends Area2D

var owner_id = null
var direction: Vector2 = Vector2.ZERO
@export var damage: int = 40
@export var speed: int = 3000

func shot(new_direction: Vector2):
	direction = new_direction

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO: #MOVING
		global_position += (speed * direction) * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.player_id == owner_id:
		return
	queue_free()
