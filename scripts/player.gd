class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_weapon: Node = $ShootWeapon
@onready var health_bar: ProgressBar = $ProgressBar
@onready var world: Node = get_node("/root/Game/World")
@onready var aim_arrow: Panel = $AimArrow
@export var player_id: int = -1
var jump_power: int = 650
var speed: int = 600
var health: int = 100
var friction: float = 6000
var impulse: Vector2 = Vector2.ZERO
var impulse_decceleration: float = 3000
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_weapon: String = "rocket_launcher"

func _ready():
	global_position = Vector2(randf_range(-1800,1800),-1100)
func _keyboard_movement(delta):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_direction: Vector2 = (mouse_pos - global_position).normalized()
	var direction: int = Input.get_axis("left", "right")

	aim_arrow.rotation = mouse_direction.angle()
	
	if direction: #RUN ANIMATION AND DIRECTION
		velocity.x = speed * direction
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, delta * friction)
	animated_sprite.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("jump") and is_on_floor(): #JUMP ANIM
		velocity.y -= jump_power
		animated_sprite.play("jump")
		
	if velocity == Vector2.ZERO: #IDLE ANIM
		animated_sprite.play("idle")
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): #SHOOT EVENT
		shoot_weapon.shoot(player_weapon, mouse_direction)
func _joystick_movement(delta):
	var axis_x = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)
	var axis_y = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)	
	
	var aim_direction = Vector2(axis_x, axis_y)
	if aim_direction.length() > 0.1: #Deadzone detection
		aim_direction = aim_direction.normalized()
	
	var suffix = str(player_id) #Player id to string
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
		
	aim_arrow.rotation = aim_direction.angle()
		
	if Input.is_action_pressed("shoot"+suffix): #SHOOT EVENT
		if aim_direction.length() == 1:
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
	impulse = impulse.move_toward(Vector2.ZERO, delta * impulse_decceleration) #Decreasing impulse using decceleration
	velocity += impulse
	move_and_slide()
