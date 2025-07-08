extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var can_collect: bool = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	can_collect = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player and can_collect == true:
		can_collect = false
		animated_sprite.play("collected")
		body.got_briefcase()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
