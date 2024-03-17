extends Area2D

signal player_lost
signal player_won

const MAX_SPEED: Vector2 = Vector2(400, 400)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600

@export var main_scene: BaseMinigame
@export var top_left_bound: Marker2D
@export var bot_right_bound: Marker2D
@export var camera: Camera2D

var debug_movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var health: int = 100

@onready var debug_mode: bool = main_scene.debug_mode
@onready var smoke_timer: Timer = get_node("SmokeTimer")

func _ready():
	smoke_timer.set_paused(true)

func _process(_delta) -> void:
	if health <= 0:
		player_lost.emit()

func _physics_process(delta: float) -> void:
	if debug_mode and Input.is_action_just_pressed("interact"):
		debug_movement_paused = !debug_movement_paused
	
	if !debug_movement_paused:
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
	if debug_mode:
		print(name + " hit a bird")
	player_lost.emit()
	
# Collision of factory
func _on_body_entered_smoke(body: Node2D) -> void:
	if !body.is_in_group("factory"):
		return
	if debug_mode:
		print(name + " is in the smoke zone of a factory")
	smoke_timer.set_paused(false)

func _on_body_exited_smoke(body: Node2D) -> void:
	if !body.is_in_group("factory"):
		return
	if debug_mode:
		print(name + " is outside the smoke zone of a factory")
	smoke_timer.set_paused(true)

func _on_smoke_timer_timeout():
	# Everytime the wait time is completed, it will decrease the health by the set number
	# Just do `wait_time*health_decrease` to get the seconds that the player can last in the smoke
	# Also, health_decrease representes the number set below
	health -= 10
	if debug_mode:
		print(name + " has a health of " + str(health))
