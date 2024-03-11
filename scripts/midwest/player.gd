extends Area2D

signal player_killed

const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600
const MAX_TORNADO_SPEED: float = 400
const TORNADO_VELOCITY: float = 500
const TORNADO_DEACCELERATION_MULTIPLIER: float = 5.0
const TORNADO_DEATH_DISTANCE: float = 10.0
const MIN_SCALE: float = 0.3
const TORNADO_BASE_ROTATION_SPEED: float = PI * 1.1

@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D
@export var debug_mode: bool
@export var max_lives: int = 3

var debug_movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var tornado: Area2D

@onready var current_lives: int = max_lives :
	set(value):
		if debug_mode:
			print("current_lives changed from %s to %s" % [current_lives, value])
		current_lives = value
		if current_lives <= 0:
			player_killed.emit()
	

func _physics_process(delta: float) -> void:
	if debug_mode and Input.is_action_just_pressed("interact"):
		debug_movement_paused = !debug_movement_paused

	if !debug_movement_paused:
		if tornado:
			tornado_move(delta)
			if debug_mode:
				camera.position += Input.get_vector("left", "right", "up", "down") * delta * AUTOSCROLL_SPEED
		else:
			move(delta)


func tornado_move(delta: float) -> void:
	var distance := global_position.distance_to(tornado.global_position)
	var direction := global_position.direction_to(tornado.global_position)
	var tornado_radius: float = tornado.collision_shape.shape.radius
	
	# Scale and rotate player as they reach the center
	scale = remap(min(distance / tornado_radius, 1), 0, 1, MIN_SCALE, 1) * Vector2.ONE
	rotate(TORNADO_BASE_ROTATION_SPEED * delta * tornado_radius / distance)
	
	# These two lines of code took a lot of hacking together to work alright. DO NOT change them
	velocity = lerp(velocity, Vector2.ZERO, delta * distance / tornado_radius * TORNADO_DEACCELERATION_MULTIPLIER)
	
	global_position = lerp(global_position + (direction.rotated(-PI / 2) * TORNADO_VELOCITY + velocity) * delta, tornado.global_position, delta * tornado_radius / distance)
	
	# Kill player if they are close to the center of the tornado
	if distance < TORNADO_DEATH_DISTANCE:
		current_lives = 0


func move(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")

	# Remove AUTOSCROLL_SPEED (added back later) so we can do calculations
	velocity.x -= AUTOSCROLL_SPEED

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

	# Basic movement. Adding back AUTOSCROLL_SPEED
	velocity.x += AUTOSCROLL_SPEED
	position += velocity * delta
	
	camera.position.x += AUTOSCROLL_SPEED * delta
	
	# Clamping position
	position.x = clampf(position.x, top_left_bound.global_position.x, bot_right_bound.global_position.x)
	position.y = clampf(position.y, top_left_bound.global_position.y, bot_right_bound.global_position.y)
	

# Obstacle
func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("obstacle"):
		return
	if debug_mode:
		print(name + " hit obstacle")
	current_lives -= 1
	body.queue_free()


# Tornado
func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("tornado") || tornado:
		return
	if debug_mode:
		print(name + " hit tornado")
	tornado = area
	tornado.path_follow_speed = 0
