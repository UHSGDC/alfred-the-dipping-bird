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

var debug_movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var was_just_hit: bool = false
var death_pause: bool = false

@onready var current_lives: int :
	set(value):
		if print_debug_messages:
			print("current_lives changed from %s to %s" % [current_lives, value])
		current_lives = max(0, value)
		lives_changed.emit(current_lives, max_lives)
		if value <= 0:
			if value == -10:
				kill("Alfred hit a skyscraper!")
			else:
				kill("Oh no! Alfred lost all his lives!")
			
@onready var hurt_animator = $HurtAnimator


func _ready() -> void:
	current_lives = max_lives


func _physics_process(delta: float) -> void:
	if debug_mode and Input.is_action_just_pressed("interact"):
		debug_movement_paused = !debug_movement_paused

	if !debug_movement_paused and !death_pause:
		move(delta)
		# Rotate based on velocity
		rotation = velocity.y / MAX_SPEED.y * MAX_ROTATION


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


func _on_hurt_animator_animation_finished(_anim_name: StringName) -> void:
	was_just_hit = false


func emit_destroy_particles(global_pos: Vector2) -> void:
	var particles: CPUParticles2D = DESTROY_PARTICLES.instantiate()
	particles.emitting = true
	add_child(particles)
	particles.global_position = global_pos
	await particles.finished
	particles.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("skyscraper"):
		on_body_entered_skyscraper(body)
	elif body.is_in_group("bird"):
		on_body_entered_bird(body)
	elif body.is_in_group("smoke"):
		on_body_entered_smoke(body)

# Collision of skyscraper
func on_body_entered_skyscraper(_body: Node2D) -> void:
	if print_debug_messages:
		print(name + " hit a skyscraper")
	current_lives = -10

# Collision of bird
func on_body_entered_bird(body: Node2D) -> void:
	if was_just_hit: # Player can't be hurt again if they were just hit
		if print_debug_messages:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if print_debug_messages:
		print(name + " hit a bird")
	current_lives -= 1
	body.kill()
	
	hurt_animator.play("hurt")
	was_just_hit = true

# Collision of smoke
func on_body_entered_smoke(_body: Node2D) -> void:
	if was_just_hit: # Player can't be hurt again if they were just hit
		if print_debug_messages:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if print_debug_messages:
		print(name + " hit smoke")
	current_lives -= 1
	
	hurt_animator.play("hurt")
	was_just_hit = true


func kill(message: String) -> void:
	$Body.hide()
	$CPUParticles2D.hide()
	$DeathParticles.emitting = true
	death_pause = true
	await $DeathParticles.finished	
	player_killed.emit(message)
