extends Area2D

signal player_lost
signal player_won(lives, coins)

const MAX_SPEED: Vector2 = Vector2(400, 0)
const ACCELERATION: Vector2 = MAX_SPEED * 10
const AUTOSCROLL_SPEED: float = 600

@export var minigame_node: BaseMinigame
@export var left_bound: Marker2D
@export var right_bound: Marker2D
@export var camera: Camera2D
@export var lives: int = 3 :
	set(value):
		lives = value
		if lives <= 0:
			if debug_mode:
				print("Player has 0 or less health")
			player_lost.emit()
			return
		if debug_mode:
			print(name + " has a health of " + str(lives))

var movement_paused: bool = false
var velocity: Vector2 = Vector2(AUTOSCROLL_SPEED, 0)
var was_just_hit: bool = false
var coins: int = 0

@onready var debug_mode: bool = minigame_node.debug_mode
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	if !movement_paused:
		move(delta)

func move(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")

	# Remove AUTOSCROLL_SPEED (added back later) so we can do calculations
	velocity.y -= AUTOSCROLL_SPEED

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
	velocity.y += AUTOSCROLL_SPEED
	position += velocity * delta
	
	camera.position.y += AUTOSCROLL_SPEED * delta
	
	# Clamping position
	position.x = clampf(position.x, left_bound.global_position.x, right_bound.global_position.x)
	position.y = clampf(position.y, left_bound.global_position.y, right_bound.global_position.y)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("tree") or body.is_in_group("boulder") or body.is_in_group("avalanche"):
		on_body_entered_tree_or_boulder_or_avalanche(body)
	elif body.is_in_group("bear"):
		on_body_entered_bear(body)

# Collision of tree or boulder or avalanche
func on_body_entered_tree_or_boulder_or_avalanche(body: Node2D) -> void:
	if debug_mode:
		print(name + " hit a(n) " + body.name)
	lives = 0

# Collision of bear
func on_body_entered_bear(body: Node2D) -> void:
	if was_just_hit: # Player can't be hurt again if they were just hit
		if debug_mode:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if debug_mode:
		print(name + " hit a bear")
	lives -= 1
	body.kill()
	timer.start()
	was_just_hit = true

# Player win
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		coins += area.value
	elif area.is_in_group("win_zone"):
		player_won.emit(lives, coins)

# Timer, which is a drop in replacement for when you implement the animation player
func _on_timer_timeout():
	was_just_hit = false
