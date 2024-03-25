extends Area2D

signal player_killed

const MAX_SPEED: float = 500
const ACCELERATION: float = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600
const MIN_SCALE: float = 0.3

const top_left_bound: Vector2 = Vector2(0, 0)
const bot_right_bound: Vector2 = Vector2(1152, 648)

var velocity: Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	velocity.y += ACCELERATION * delta 

	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	#velocity = velocity.move_toward(velocity.normalized() * MAX_SPEED, sand_acceleration * 2 * delta)

	position.y += velocity.y * delta
	
	if position.y > bot_right_bound.y:
		queue_free()
	

# Obstacle
func _on_body_entered(body: Node2D) -> void:
	print("test")
