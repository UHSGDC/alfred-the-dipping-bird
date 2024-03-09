extends Area2D


const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10

@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:

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
	
	# Clamping position
	position.x = clampf(position.x, top_left_bound.position.x, bot_right_bound.position.x)
	position.y = clampf(position.y, top_left_bound.position.y, bot_right_bound.position.y)



func _on_area_entered(area: Area2D) -> void:
	print(name + " hit obstacle")
