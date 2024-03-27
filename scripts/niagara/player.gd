extends Area2D

signal player_killed

const MAX_SPEED: float = 400
const MAX_FALL_SPEED: float = 700
const ACCELERATION: float = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600
const MIN_SCALE: float = 0.3

const left_bound: float = 16
const right_bound: float = 632

var velocity: Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:	
	var input := Input.get_vector("left", "right", "up", "down")
	
	if input.x:
		velocity.x += input.x * ACCELERATION * delta
	elif velocity.x != 0: 
		if absf(velocity.x) < ACCELERATION * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * ACCELERATION * delta

	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)

	position.x += velocity.x * delta
	position.x = clampf(position.x, left_bound, right_bound)
	
# Obstacle
func _on_area_entered(body: Node2D) -> void:
	print("test")
