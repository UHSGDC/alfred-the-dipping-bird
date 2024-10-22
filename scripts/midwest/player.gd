extends Area2D

signal player_killed(message: String)
signal lives_changed(new_lives: int, max_lives: int)

const DESTROY_PARTICLES: PackedScene = preload("res://scenes/midwest/destroy_particles.tscn")
const MAX_ROTATION: float = PI / 8
const MAX_SPEED: Vector2 = Vector2(150, 150)
const ACCELERATION: Vector2 = MAX_SPEED * 16
const AUTOSCROLL_SPEED: float = 150
const MAX_TORNADO_SPEED: float = 120
const TORNADO_VELOCITY: float = 140
const TORNADO_DEACCELERATION_MULTIPLIER: float = 5.0
const TORNADO_DEATH_DISTANCE: float = 10.0
const MIN_SCALE: float = 0.3
const TORNADO_BASE_ROTATION_SPEED: float = PI * 0.7

@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D
@export var debug_mode: bool
@export var print_debug_messages: bool
@export var max_lives: int = 3
@export var hurt_sound: AudioStreamPlayer

var debug_movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var tornado: Area2D
var was_just_hit: bool = false
var death_pause: bool = false

var screen_shake_pos: Vector2
var screen_shake: bool = false :
	set(value):
		screen_shake = value
		if value:
			screen_shake_pos = camera.position
		else:
			camera.position = screen_shake_pos

@onready var current_lives: int :
	set(value):
		if print_debug_messages:
			print("current_lives changed from %s to %s" % [current_lives, value])
		current_lives = value
		lives_changed.emit(value, max_lives)
		if current_lives <= 0:
			if current_lives == -10:
				kill("Alfred got sucked into a tornado!")
			else:
				kill("Oh no! Alfred lost all his lives!")
			
@onready var hurt_animator = $HurtAnimator


func _ready() -> void:
	current_lives = max_lives
	$HurtAnimator.play("RESET")


func _physics_process(delta: float) -> void:
	if screen_shake:
		camera.position = screen_shake_pos + Vector2.RIGHT.rotated(randf_range(-PI, PI))
	
	if debug_mode and Input.is_action_just_pressed("interact"):
		debug_movement_paused = !debug_movement_paused

	if !debug_movement_paused and !death_pause:
		if tornado:
			tornado_move(delta)
			if debug_mode:
				camera.position += Input.get_vector("left", "right", "up", "down") * delta * AUTOSCROLL_SPEED
		else:
			move(delta)
			# Rotate based on velocity
			rotation = velocity.y / MAX_SPEED.y * MAX_ROTATION


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
		current_lives = -10


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
	
	# Zero out velocity if on edge of screen
	if position.x == top_left_bound.global_position.x or position.x == bot_right_bound.global_position.x:
		velocity.x = AUTOSCROLL_SPEED
	if position.y == top_left_bound.global_position.y or position.y == bot_right_bound.global_position.y:
		velocity.y = move_toward(velocity.y, 0, ACCELERATION.y * 2 * delta) # We use lerp so that player rotation is still smooth
	

# Obstacle
func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("obstacle"):
		return
	if was_just_hit: # Player can't be hurt again if they were just hit
		if print_debug_messages:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if print_debug_messages:
		print(name + " hit obstacle")
	current_lives -= 1
	emit_destroy_particles(body.global_position)
	body.queue_free()
	
	hurt_animator.play("hurt")
	was_just_hit = true
	

# Tornado
func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("tornado") || tornado:
		return
	if print_debug_messages:
		print(name + " hit tornado")
	tornado = area
	tornado.path_follow_speed = 0
	$TornadoSound.play()


func _on_hurt_animator_animation_finished(_anim_name: StringName) -> void:
	was_just_hit = false


func emit_destroy_particles(global_pos: Vector2) -> void:
	var particles: CPUParticles2D = DESTROY_PARTICLES.instantiate()
	particles.emitting = true
	add_child(particles)
	particles.global_position = global_pos
	await particles.finished
	particles.queue_free()


func kill(message: String) -> void:
	$Body.hide()
	$CPUParticles2D.hide()
	$DeathParticles.emitting = true
	death_pause = true
	$HurtSound.play()
	screen_shake = true
	$Timer.start(0.3)
	await $Timer.timeout
	screen_shake = false
	await $DeathParticles.finished	
	player_killed.emit(message)
