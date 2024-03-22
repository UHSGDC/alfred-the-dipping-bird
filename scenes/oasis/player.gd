extends CharacterBody2D

@export var max_speed: float
@export var sand_acceleration: float
@export var air_acceleration_multiplier: float

var in_air: bool = false

@onready var bird_sprite: Sprite2D = $BirdSprite


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	move(delta, input)
	look(input)
	
	
func look(input: Vector2) -> void:
	if input != Vector2.ZERO:
		bird_sprite.rotation = input.angle()


func move(delta: float, input: Vector2) -> void:	
	var acceleration := sand_acceleration
	if in_air:
		acceleration *= air_acceleration_multiplier
		
		
	if input.y: # Acceleration
		velocity.y += input.y * acceleration * delta
	elif velocity.y != 0: # Deacceleration
		if absf(velocity.y) < acceleration * delta:
			velocity.y = 0
		else:
			velocity.y += -signf(velocity.y) * acceleration * delta
	
	# Horizontal
	if input.x: # Acceleration
		velocity.x += input.x * acceleration * delta
	elif velocity.x != 0: # Deacceleration
		if absf(velocity.x) < acceleration * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * acceleration * delta
	
	# Slow down player down to max speed if they are on the ground and above the max speed 		
	if !in_air and velocity.length() > max_speed:
		# Move toward stops this from making the velocity below max_speed
		velocity = velocity.move_toward(velocity.normalized() * max_speed, sand_acceleration * 2 * delta)
	print(velocity, velocity.length())
	move_and_slide()
