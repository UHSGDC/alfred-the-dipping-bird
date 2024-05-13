extends Area2D

signal wetness_changed(current_wetness: float, max_wetness: float)

const MAX_ROTATION: float = PI / 8
const MAX_SPEED: float = 150
const ACCELERATION: float = MAX_SPEED * 10

const LEFT_BOUND: float = 8
const RIGHT_BOUND: float = 320 - LEFT_BOUND
const DRY_SPEED: float = 7.0
const WET_SPEED: float = 10.0
## Wetness applied right after entering water
const INSTANT_WETNESS: float = 3.0
const MAX_WETNESS: float = 100

var velocity: Vector2 = Vector2(0, 0)

var in_water: bool = false
# Turns on after a given time after the player leaves the water
var drying: bool = true
var current_wetness: float :
	set(value):
		current_wetness = value
		wetness_changed.emit(current_wetness, MAX_WETNESS)
var death_pause: bool = false

func _physics_process(delta: float) -> void:
	move(delta)
	if !death_pause:
		if in_water:
			current_wetness += WET_SPEED * delta
		elif drying:
			current_wetness -= DRY_SPEED * delta
		
	rotation = -velocity.x / MAX_SPEED * MAX_ROTATION


func move(delta: float) -> void:	
	var input := Input.get_vector("left", "right", "up", "down")
	if death_pause:
		input = Vector2.ZERO
		if velocity.y:
			velocity.y += ACCELERATION * delta
			position.y += velocity.y * delta
	if input.x:
		velocity.x += input.x * ACCELERATION * delta
	elif velocity.x != 0: 
		if absf(velocity.x) < ACCELERATION * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * ACCELERATION * delta

	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)

	position.x += velocity.x * delta
	position.x = clampf(position.x, LEFT_BOUND, RIGHT_BOUND)


# Waterfall detection
func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("waterfall"):
		in_water = true
		current_wetness += INSTANT_WETNESS
		drying = false
		$DryingTimer.stop()


# Waterfall detection
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("waterfall"):
		in_water = false
		$DryingTimer.start()


func _on_drying_timer_timeout() -> void:
	drying = true


func kill() -> void:
	$Body.hide()
	$CPUParticles2D.hide()
	$DeathParticles.emitting = true
	death_pause = true
	await $DeathParticles.finished


func fall() -> void:
	death_pause = true
	velocity.y = 1
	await $VisibleOnScreenNotifier2D.screen_exited

