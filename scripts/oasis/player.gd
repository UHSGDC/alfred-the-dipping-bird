extends CharacterBody2D

signal player_killed
signal water_changed(current_value: float, max_value: float)

@export var max_ground_speed: float
@export var max_air_speed: float
@export var ground_acceleration: float
@export var air_acceleration_multiplier: float

@export var max_jump_scale: float
@export var jump_time: float
@export var fall_time: float
## Cooldown before player can collide (not ride) again with a camel it just dismounted
@export var same_camel_collision_cooldown: float = 0.5
@export var max_water: float = 100.0
## Per second how much water is consumed
@export var water_per_second: float = 1.0
## Per second how much additional water is consumed when Alfred walks
@export var water_per_second_walk: float = 1.0
## How much water is consumed when Alfred jumps. Applied once per jump
@export var water_per_jump: float = 3.0

var in_air: bool = false
var camel: StaticBody2D : set = _set_camel

@onready var current_water: float = max_water : set = _set_current_water
@onready var bird_sprite: Sprite2D = $BirdSprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var camel_detector: Area2D = $CamelDetector


func _physics_process(delta: float) -> void:
	# Consume water
	current_water -= water_per_second * delta
	
	var input := Input.get_vector("left", "right", "up", "down")
	if camel:
		camel_move(delta)
	else:
		move(delta, input)
		# Consume walk water
		if !in_air and input != Vector2.ZERO:
			current_water -= water_per_second_walk * delta
	look(input)
	animate()
	
	# jumping/dismounting
	if !in_air and Input.is_action_just_pressed("interact"):
		# Consume jump water
		current_water -= water_per_jump
		jump()
	
	
func look(input: Vector2) -> void:
	if input != Vector2.ZERO:
		global_rotation = input.angle()
	elif camel:
		global_rotation = camel.global_rotation


func jump() -> void:
	if camel: # Dismount camel
		camel = null
	elif camel_detector.get_overlapping_bodies(): # Allow player to instantly mount camel after jumping
		camel = camel_detector.get_overlapping_bodies()[0]
			
	in_air = true	
	anim_player.play("jump")
	await anim_player.animation_finished
	in_air = false


func animate() -> void:
	if camel:
		# Let jump animation finish (let player fully land on camel) before playing ride animation
		if anim_player.current_animation != "jump":
			anim_player.play("ride")
	elif in_air:
		anim_player.play("jump")
	elif velocity != Vector2.ZERO:
		anim_player.play("walk")
	else:
		anim_player.play("idle")
		

func camel_move(_delta: float) -> void:
	global_position = camel.global_position
	bird_sprite.scale = camel.sprite.scale


func move(delta: float, input: Vector2) -> void:	
	var acceleration := ground_acceleration
	var max_speed := max_ground_speed
	if in_air:
		acceleration *= air_acceleration_multiplier
		max_speed = max_air_speed
		
	if input.y: # Acceleration
		velocity.y += input.y * acceleration * delta
	elif velocity.y != 0: # Deacceleration
		if absf(velocity.y) < acceleration * delta:
			velocity.y = 0
		else:
			velocity.y += -signf(velocity.y) * acceleration * delta
	
	# Horizontal
	if input.x: # Acceleration
		velocity.x += input.x * acceleration * delta
	elif velocity.x != 0: # Deacceleration
		if absf(velocity.x) < acceleration * delta:
			velocity.x = 0
		else:
			velocity.x += -signf(velocity.x) * acceleration * delta
	
	# Slow down player down to max speed if they are on the ground and above the max speed 	
	if velocity.length() > max_speed:
		# Move toward stops this from making the velocity below max_speed
		velocity = velocity.move_toward(velocity.normalized() * max_speed, acceleration * 2 * delta)
	move_and_slide()


func _set_current_water(value: float) -> void:
	if value <= 0:
		player_killed.emit()
	
	current_water = value if value > 0 else 0.0
	water_changed.emit(current_water, max_water)	


func _set_camel(value: StaticBody2D) -> void:	
	var old_value := camel
	camel = value
	
	# If dismounting camel
	if old_value:
		# Give player velocity after dismounting based off input.
		velocity = Input.get_vector("left", "right", "up", "down") * max_ground_speed
		add_collision_exception_with(old_value)
		await get_tree().create_timer(same_camel_collision_cooldown).timeout
		remove_collision_exception_with(old_value)


func _on_camel_detector_body_entered(body: Node2D) -> void:
	if in_air and body.is_in_group("camel"):
		camel = body
