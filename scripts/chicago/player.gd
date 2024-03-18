extends Area2D

signal player_lost
signal player_won(lives: int)

const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600

@export var minigame_node: BaseMinigame
@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D
@export var lives: int = 3 :
	set(value):
		lives = value
		if debug_mode:
			print(name + " has a health of " + str(lives))
		if lives <= 0:
			if debug_mode:
				print("Player has 0 or less health")
			player_lost.emit()

var movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)

@onready var debug_mode: bool = minigame_node.debug_mode
@onready var pigeon_particles: CPUParticles2D = $PigeonParticles

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

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("skyscraper"):
		on_body_entered_skyscraper(body)
	elif body.is_in_group("bird"):
		on_body_entered_bird(body)
	elif body.is_in_group("smoke"):
		on_body_entered_smoke(body)

# Collision of skyscraper
func on_body_entered_skyscraper(_body: Node2D) -> void:
	if debug_mode:
		print(name + " hit a skyscraper")
	player_lost.emit()

# Collision of bird
func on_body_entered_bird(body: Node2D) -> void:
	lives -= 1
	if debug_mode:
		print(name + " hit a bird")
	body.queue_free()
	pigeon_particles.emitting = true

# Collision of smoke
func on_body_entered_smoke(_body: Node2D) -> void:
	lives -= 1
	if debug_mode:
		print(name + " hit smoke")


# Player win
func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("win_zone"):
		return
	player_won.emit(lives)




