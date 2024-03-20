extends CharacterBody2D

signal player_killed

const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600
const MIN_SCALE: float = 0.3

const top_left_bound: Vector2 = Vector2(0, 0)
const bot_right_bound: Vector2 = Vector2(1920, 1080)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	
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

	# Basic movement. Adding back AUTOSCROLL_SPEED
	move_and_collide(velocity * delta)
	
	# Clamping position
	position.x = clampf(position.x, top_left_bound.x, bot_right_bound.x)
	# position.y = clampf(position.y, top_left_bound.global_position.y, bot_right_bound.global_position.y)
	

# Obstacle
func _on_body_entered(body: Node2D) -> void:
	print("test")
