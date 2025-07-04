extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var collected = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not collected:
		animated_sprite.play("collected")
		body.got_briefcase()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
