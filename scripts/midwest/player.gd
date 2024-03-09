extends Area2D


const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600

@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D
@export var debug_pause_movement: bool

var debug_movement_paused: bool = false

var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if debug_pause_movement:
		if Input.is_action_just_pressed("interact"):
			debug_movement_paused = !debug_movement_paused
		if !debug_movement_paused:
			move(delta)
	else:
		move(delta)
	

func move(delta: float) -> void:
	camera.position.x += AUTOSCROLL_SPEED * delta

	var input := Input.get_vector("left", "right", "up", "down")

	# Vertical
	if input.y: # Acceleration
		velocity.y += input.y * ACCELERATION.y * delta
	elif velocity.y != 0: # Deacceleration
		if absf(velocity.y) < ACCELERATION.y * delta:
			velocity.y = 0
		else:
			velocity.y += -signf(velocity.y) * ACCELERATION.y * delta
	
	# Horizontal
	if input.x: # Acceleration
		velocity.x += input.x * ACCELERATION.x * delta
	elif velocity.x != 0: # Deacceleration
		if absf(velocity.x) < ACCELERATION.x * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * ACCELERATION.x * delta

	# Capping speed
	velocity.x = clampf(velocity.x, -MAX_SPEED.x, MAX_SPEED.x)
	velocity.y = clampf(velocity.y, -MAX_SPEED.y, MAX_SPEED.y)

	# Basic movement
	position += velocity * delta
	position.x += AUTOSCROLL_SPEED * delta
	
	# Clamping position
	position.x = clampf(position.x, top_left_bound.global_position.x, bot_right_bound.global_position.x)
	position.y = clampf(position.y, top_left_bound.global_position.y, bot_right_bound.global_position.y)
	

func _on_body_entered(body: Node2D) -> void:
	print(name + " hit obstacle")
