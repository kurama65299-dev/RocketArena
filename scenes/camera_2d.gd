extends Camera2D

var shake_decay: float = 8.0
var shake_strength: float = 0.0

func trigger_camera_shake(strength: float):
	if strength > shake_strength:
		shake_strength = strength
	else:
		shake_strength += strength

func _process(delta: float):
	if shake_strength > 0:
		var shake_offset = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
		) * shake_strength
		offset = shake_offset
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO
