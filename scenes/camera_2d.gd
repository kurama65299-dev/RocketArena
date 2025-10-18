extends Camera2D

var shake_decay: float = 12.0
var shake_strength: float = 0.0
var max_shake: float = 30.0

var max_duration: float = 3.0
var duration: float = 0.0

func trigger_camera_shake(strength: float):
	shake_strength += strength
		
	shake_strength = shake_strength - GlobalSettings.players.size()
	
	if shake_strength >= max_shake:
		shake_strength = max_shake

func _process(delta: float):
	if shake_strength > 0:
		var shake_offset = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
		) * shake_strength
		offset = shake_offset
		shake_strength = max(shake_strength - shake_decay * delta, 0)
		
		if shake_strength > max_shake / 2:
			duration += delta
			if duration >= max_duration:
				duration = 0.0
				shake_strength = 0.0
	else:
		offset = Vector2.ZERO
