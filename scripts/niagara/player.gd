extends Area2D

const MAX_SPEED: float = 150
const ACCELERATION: float = MAX_SPEED * 10

const LEFT_BOUND: float = 8
const RIGHT_BOUND: float = 320 - LEFT_BOUND

var velocity: Vector2 = Vector2(0, 0)

var in_water: bool = false

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
	position.x = clampf(position.x, LEFT_BOUND, RIGHT_BOUND)


# Waterfall detection
func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("waterfall"):
		in_water = true


# Waterfall detection
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("waterfall"):
		in_water = false
