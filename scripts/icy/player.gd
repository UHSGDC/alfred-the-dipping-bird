extends CharacterBody2D

@export var ground_acceleration: float
@export var max_ground_speed: float
@export var ice_acceleration: float
@export var max_ice_speed: float
@export var jump_acceleration: float
@export var max_jump_speed: float
@export var direction_change_multilpier: float

var on_ice: bool = false
var in_air: bool = false
var weak_spot: Area2D = null
var falling: bool = false # falling into water

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if falling:
		move(delta, Vector2.ZERO)
	else:
		move(delta, input)
	look(input)
	animate()
	
	# jumping
	if !falling and !in_air and Input.is_action_just_pressed("interact"):
		jump()


func jump() -> void:
	in_air = true
	anim_player.play("jump")
	await anim_player.animation_finished
	in_air = false
	if weak_spot:
		weak_spot.crack()


func look(input: Vector2) -> void:
	if input != Vector2.ZERO:
		global_rotation = input.angle()


func animate() -> void:
	if in_air:
		anim_player.play("jump")
	elif velocity != Vector2.ZERO:
		anim_player.play("walk")
	else:
		anim_player.play("idle")


func move(delta: float, input: Vector2) -> void:
	var acceleration := ground_acceleration
	var max_speed := max_ground_speed
	if in_air:
		acceleration = jump_acceleration
		max_speed = max_jump_speed
	elif on_ice:
		acceleration = ice_acceleration
		max_speed = max_ice_speed
	
	if input.y: # Acceleration
		# Double acceleration if player is moving in other direction of input
		if signf(input.y) != signf(velocity.y):
			velocity.y += direction_change_multilpier * input.y * acceleration * delta
		else:
			velocity.y += input.y * acceleration * delta
	#elif velocity.y != 0: # Deacceleration
		#if absf(velocity.y) < acceleration * delta:
			#velocity.y = 0
		#else:
			#velocity.y += -signf(velocity.y) * acceleration * delta
	
	# Horizontal
	if input.x: # Acceleration
		# Double acceleration if player is moving in other direction of input
		if signf(input.x) != signf(velocity.x):
			velocity.x += direction_change_multilpier * input.x * acceleration * delta
		else:
			velocity.x += input.x * acceleration * delta
	#elif velocity.x != 0: # Deacceleration
		#if absf(velocity.x) < acceleration * delta:
			#velocity.x = 0
		#else:
			#velocity.x += -signf(velocity.x) * acceleration * delta
	
	# Better Deacceleration
	if input == Vector2.ZERO and velocity != Vector2.ZERO:
		if abs(velocity) < velocity.normalized() * acceleration * delta:
			velocity = Vector2.ZERO
		else:
			velocity += -velocity.normalized() * acceleration * delta
	
	# Slow down player down to max speed if they are on the ground and above the max speed 	
	if velocity.length() > max_speed:
		# Move toward stops this from making the velocity below max_speed
		velocity = velocity.move_toward(velocity.normalized() * max_speed, acceleration * 2 * delta)
	
	move_and_slide()


func _on_ice_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("ice"):
		on_ice = true


func _on_ice_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("ice"):
		on_ice = false


func _on_weak_spot_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("weak_spot"):
		weak_spot = area


func _on_weak_spot_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("weak_spot"):
		weak_spot = null


func splash() -> void:
	$SplashParticle.restart()
	$DeathSound.play()
