class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_weapon: Node = $ShootWeapon
@onready var health_bar: ProgressBar = $ProgressBar
@onready var world: Node = get_node("/root/Game/World")
@export var player_id: int = -1
var jump_power: int = 550
var speed: int = 450
var health: int = 100
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_weapon: String = "rocket_launcher"

func _ready():
	global_position = Vector2(randf_range(-2000,2000),-1200)
func _keyboard_movement(delta):
	var direction: int = Input.get_axis("left", "right")
	
	if direction: #RUN ANIMATION AND DIRECTION
		velocity.x = speed * direction
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = 0 #NOT MOVING
		
	animated_sprite.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("jump") and is_on_floor(): #JUMP ANIM
		velocity.y -= jump_power
		animated_sprite.play("jump")
		
	if velocity == Vector2.ZERO: #IDLE ANIM
		animated_sprite.play("idle")
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): #SHOOT EVENT
		var mouse_pos = get_global_mouse_position()
		var mouse_direction = (mouse_pos - global_position).normalized()
		shoot_weapon.shoot(player_weapon, mouse_direction)
func _joystick_movement(delta):
	var axis_x = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)
	var axis_y = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)	
	var suffix = str(player_id)
	
	if Input.is_action_pressed("left"+suffix): #MOVEMENT
		velocity.x = speed * -1
		animated_sprite.play("run")
	elif Input.is_action_pressed("right"+suffix):
		velocity.x = speed * 1
		animated_sprite.play("run")
	else:
		velocity.x = 0

	animated_sprite.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("jump"+suffix) and is_on_floor(): #JUMP ANIM
		velocity.y -= jump_power
		animated_sprite.play("jump")
		
	if velocity == Vector2.ZERO: #IDLE ANIM
		animated_sprite.play("idle")
		
	if Input.is_action_pressed("shoot"+suffix): #SHOOT EVENT
		var aim_direction = Vector2(axis_x, axis_y)
		if aim_direction.length() > 0.1:
			aim_direction = aim_direction.normalized()
			shoot_weapon.shoot(player_weapon, aim_direction)

func _process(delta: float) -> void:
	health_bar.value = health
	if health <= 0:
		world.respawn(player_id)
		queue_free()

func _physics_process(delta : float) -> void:
	if !is_on_floor(): #GRAVITY
		velocity.y += gravity * delta
		
	if player_id == -1:
		_keyboard_movement(delta)
	else:
		_joystick_movement(delta)
	move_and_slide()
