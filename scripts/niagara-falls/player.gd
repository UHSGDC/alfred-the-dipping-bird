extends Area2D

signal player_killed

const MAX_SPEED: float = 400
const MAX_FALL_SPEED: float = 700
const ACCELERATION: float = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600
const MIN_SCALE: float = 0.3

const top_left_bound: Vector2 = Vector2(0, 0)
const bot_right_bound: Vector2 = Vector2(1152, 648)

var velocity: Vector2 = Vector2(0, 0)
var dead: bool

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	if dead:
		return
	
	var input := Input.get_vector("left", "right", "up", "down")
	
	if input.x:
		velocity.x += input.x * ACCELERATION * delta
	elif velocity.x != 0: 
		if absf(velocity.x) < ACCELERATION * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * ACCELERATION * delta

	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	#velocity = velocity.move_toward(velocity.normalized() * MAX_SPEED, sand_acceleration * 2 * delta)

	position.x += velocity.x * delta
	position.x = clampf(position.x, top_left_bound.x, bot_right_bound.x)
	# position.y = clampf(position.y, top_left_bound.global_position.y, bot_right_bound.global_position.y)
	
# Obstacle
func _on_area_entered(body: Node2D) -> void:
	print("test")
