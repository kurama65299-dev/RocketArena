extends CharacterBody2D

var jump_power = 500
var speed = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta : float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y -= jump_power
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = speed * direction
	else:
		velocity.x = 0
	
	move_and_slide()
