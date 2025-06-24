class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_weapon: Node = $ShootWeapon
@onready var health_bar: ProgressBar = $ProgressBar

var jump_power = 750
var speed = 350
var health = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_weapon = "rocket_launcher"

func _process(delta: float) -> void:
	health_bar.value = health
	if health <= 0:
		queue_free()

func _physics_process(delta : float) -> void:
	if !is_on_floor(): #GRAVITY
		velocity.y += gravity * delta
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction: #RUN ANIMATION AND DIRECTION
		velocity.x = speed * direction
		animated_sprite.flip_h = direction < 0
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = 0 #NOT MOVING
	
	if Input.is_action_pressed("ui_up") and is_on_floor(): #JUMP ANIM
		velocity.y -= jump_power
		animated_sprite.play("jump")
		
	if velocity == Vector2.ZERO: #IDLE ANIM
		animated_sprite.play("idle")
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): #SHOOT EVENT
		shoot_weapon.shoot(player_weapon)
	move_and_slide()
