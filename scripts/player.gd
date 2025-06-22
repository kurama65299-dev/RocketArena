extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var jump_power = 500
var speed = 300
var cooldowns : Dictionary = {
	"rocket_launcher" : true
}
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var rocket_launcher_timer: Timer = $Weapons/Cooldowns/RocketLauncher

func _physics_process(delta : float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = speed * direction
		animated_sprite.flip_h = direction < 0
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = 0
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y -= jump_power
		animated_sprite.play("jump")
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if cooldowns["rocket_launcher"] == true:
			var weapon = preload("res://scenes/rocket_launcher.tscn")
			var new_weapon = weapon.instantiate()
			$AnimatedSprite2D.add_child(new_weapon)
			new_weapon.get_node("Sprite2D").flip_h = $AnimatedSprite2D.flip_h
			new_weapon.global_position = position
			new_weapon.get_node("AnimationPlayer").play("shoot")
			cooldowns["rocket_launcher"] = false
			rocket_launcher_timer.start()
	move_and_slide()

func _on_rocket_launcher_timeout() -> void:
	cooldowns["rocket_launcher"] = true
