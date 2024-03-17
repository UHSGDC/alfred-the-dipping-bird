extends Area2D

signal player_lost
signal player_won

const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600

@export var main_node: BaseMinigame
@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D

var movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var health: int = 100

@onready var debug_mode: bool = main_node.debug_mode
@onready var smoke_timer: Timer = get_node("Smoke Timer")
@onready var smoke_particles_timer: Timer = get_node("Smoke Particles Timer")
@onready var smoke_particles_emitter: CPUParticles2D = get_node("Smoke Particles Emitter")
@onready var enemy_bird_particles_emitter: CPUParticles2D = get_node("Enemy Bird Particles Emitter")

func _ready():
	smoke_timer.set_paused(true)

func _process(_delta) -> void:
	if health <= 0:
		if debug_mode:
			print("Player has 0 or less health")
		player_lost.emit()

func _physics_process(delta: float) -> void:
	if !movement_paused:
		move(delta)

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

# Collision of skyscraper
func _on_body_entered_skyscraper(body: Node2D) -> void:
	if !body.is_in_group("skyscraper"):
		return
	if debug_mode:
		print(name + " hit a skyscraper")
	player_lost.emit()

# Collision of bird
func _on_body_entered_bird(body: Node2D) -> void:
	if !body.is_in_group("bird"):
		return
	health -= 25
	if debug_mode:
		print(name + " hit a bird")
		print(name + " has a health of " + str(health))
	body.queue_free()
	enemy_bird_particles_emitter.emitting = true

# Collision of factory
func _on_body_entered_smoke(body: Node2D) -> void:
	if !body.is_in_group("factory"):
		return
	if debug_mode:
		print(name + " is in the smoke zone of a factory")
	smoke_timer.set_paused(false)
	smoke_particles_emitter.emitting = true
	smoke_particles_timer.stop()

func _on_body_exited_smoke(body: Node2D) -> void:
	if !body.is_in_group("factory"):
		return
	if debug_mode:
		print(name + " is outside the smoke zone of a factory")
	smoke_timer.set_paused(true)
	smoke_particles_timer.start()

func _on_smoke_timer_timeout():
	# Everytime the wait time is completed, it will decrease the health by the set number
	# Just do `wait_time*health_decrease` to get the seconds that the player can last in the smoke
	# Also, health_decrease representes the number set below
	health -= 10
	if debug_mode:
		print(name + " has a health of " + str(health))

func _on_particles_timer_timeout():
	smoke_particles_emitter.emitting = false
	if debug_mode:
		print("Particle timer has timed out")

# Collision of win zone
func _on_body_entered_win_zone(body:Node2D) -> void:
	if !body.is_in_group("win_zone"):
		return
	player_won.emit()

func _on_area_entered_win_zone(area: Area2D) -> void:
	if !area.is_in_group("win_zone"):
		return
	player_won.emit()
