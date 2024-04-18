extends Area2D

signal player_lost
signal player_won(lives: int)

const MAX_SPEED: Vector2 = Vector2(0, 400)
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
var was_just_hit: bool = false

@onready var debug_mode: bool = minigame_node.debug_mode
@onready var anim_player: AnimationPlayer = $AnimationPlayer

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
	lives = 0

# Collision of bird
func on_body_entered_bird(body: Node2D) -> void:
	if was_just_hit: # Player can't be hurt again if they were just hit
		if debug_mode:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if debug_mode:
		print(name + " hit a bird")
	lives -= 1
	body.kill()
	
	anim_player.play("hurt")
	was_just_hit = true

# Collision of smoke
func on_body_entered_smoke(_body: Node2D) -> void:
	if was_just_hit: # Player can't be hurt again if they were just hit
		if debug_mode:
			print(name + " hit obstacle, but player was just hit, so no damage inflicted")
		return
	if debug_mode:
		print(name + " hit smoke")
	lives -= 1
	
	anim_player.play("hurt")
	was_just_hit = true


# Player win
func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("win_zone"):
		return
	player_won.emit(lives)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	was_just_hit = false

