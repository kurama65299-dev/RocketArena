class_name Player
extends CharacterBody2D

const BRIEFCASE = preload("res://scenes/briefcase.tscn")
@onready var damaged_timer: Timer = $Damaged
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_weapon: Node = $ShootWeapon
@onready var health_bar: ProgressBar = $ProgressBar
@onready var world: Node = get_node("/root/Game/World")
@onready var aim_arrow: Panel = $AimArrow
@export var player_id: int = -1
@onready var game = get_node("/root/Game")
var jump_power: int = 650
var speed: int = 600
var health: int = 100
var max_health: int = 100
var friction: float = 6000
var impulse: Vector2 = Vector2.ZERO
var impulse_deceleration: float = 3000
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_weapon: String = "rocket_launcher"
var has_briefcase: bool = false
var is_dead: bool = false
var team = 0

func _ready():
	update_health_bar()
	global_position = Vector2(randf_range(-1800,1800),-1100)
func _keyboard_movement(delta):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_direction: Vector2 = (mouse_pos - global_position).normalized()
	var direction: int = Input.get_axis("left", "right")

	aim_arrow.rotation = mouse_direction.angle()
	
	if abs(impulse.x) == 0:
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
	if abs(impulse.x) == 0:
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


func _physics_process(delta : float) -> void:
	if !is_on_floor(): #GRAVITY
		velocity.y += gravity * delta
		
	if player_id == -1:
		_keyboard_movement(delta)
	else:
		_joystick_movement(delta)
	impulse = impulse.move_toward(Vector2.ZERO, delta * impulse_deceleration) #Decreasing impulse using decceleration
	velocity += impulse
	move_and_slide()

func damage(damage, enemy_id):
	if is_dead:
		return
	if GlobalSettings.teams_enabled:
		for player in GlobalSettings.players:
			if player.Device == enemy_id and player.Team == team:
				return

	health -= damage
	
	if health <= 0:
		is_dead = true
		world.respawn(player_id)
		game.on_player_death(player_id, enemy_id)
		if GlobalSettings.gamemode == "keep_the_briefcase" and has_briefcase:
			var new_briefcase = BRIEFCASE.instantiate()
			new_briefcase.global_position = global_position
			world.add_child(new_briefcase)
		queue_free()
		
	update_health_bar()
	darken_on_damage()
	damaged_timer.start()

func heal(heal):
	health += heal
	if health > max_health:
		health = max_health
	update_health_bar()

func update_health_bar():
	health_bar.value = health

func _on_heal_timeout() -> void:
	heal(10)

func _on_damaged_timeout() -> void:
	modulate = Color.from_hsv(0,0,100/100,1)

func darken_on_damage():
	modulate = Color.from_hsv(0,0,73 / 100,1)

func got_briefcase():
	has_briefcase = true
	while(true):
		await get_tree().create_timer(1).timeout
		game.kept_briefcase(team)
