extends CharacterBody2D

@export var ground_acceleration: float
@export var max_ground_speed: float
@export var ice_acceleration: float
@export var max_ice_speed: float

var on_ice: bool = false


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:	
	var input := Input.get_vector("left", "right", "up", "down")
	var acceleration := ground_acceleration
	var max_speed := max_ground_speed
	if on_ice:
		acceleration = ice_acceleration
		max_speed = max_ice_speed
	
	if input.y: # Acceleration
		# Double acceleration if player is moving in other direction of input
		if input.y != signf(velocity.y):
			velocity.y += 2 * input.y * acceleration * delta
		else:
			velocity.y += input.y * acceleration * delta
	elif velocity.y != 0: # Deacceleration
		if absf(velocity.y) < acceleration * delta:
			velocity.y = 0
		else:
			velocity.y += -signf(velocity.y) * acceleration * delta
	
	# Horizontal
	if input.x: # Acceleration
		# Double acceleration if player is moving in other direction of input
		if input.x != signf(velocity.x):
			velocity.x += 2 * input.x * acceleration * delta
		else:
			velocity.x += input.x * acceleration * delta
	elif velocity.x != 0: # Deacceleration
		if absf(velocity.x) < acceleration * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * acceleration * delta
	
	# Slow down player down to max speed if they are on the ground and above the max speed 	
	if velocity.length() > max_speed:
		# Move toward stops this from making the velocity below max_speed
		velocity = velocity.move_toward(velocity.normalized() * max_speed, acceleration * 2 * delta)
	
	move_and_slide()
