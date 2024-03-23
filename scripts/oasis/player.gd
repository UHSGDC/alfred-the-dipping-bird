extends CharacterBody2D

@export var max_ground_speed: float
@export var max_air_speed: float
@export var ground_acceleration: float
@export var air_acceleration_multiplier: float

@export var max_jump_scale: float
@export var jump_time: float
@export var fall_time: float
## Cooldown before player can collide (not ride) again with a camel it just dismounted
@export var same_camel_collision_cooldown: float = 0.5

var in_air: bool = false
var camel: StaticBody2D : set = _set_camel

@onready var bird_sprite: Sprite2D = $BirdSprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if camel:
		camel_move(delta)
	else:
		move(delta, input)
	look(input)
	animate()
	
	# jumping/dismounting
	if !in_air and Input.is_action_just_pressed("interact"):
		jump()
	
	
func look(input: Vector2) -> void:
	if input != Vector2.ZERO:
		rotation = input.angle()
	elif camel:
		rotation = camel.global_rotation


func jump() -> void:
	if camel:
		camel = null
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
	elif velocity == Vector2.ZERO:
		anim_player.play("idle")
	else:
		anim_player.play("walk")
		

func camel_move(_delta: float) -> void:
	global_position = camel.global_position


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


func _set_camel(value: StaticBody2D) -> void:
	# Sets the frame to 1 if there is a value. Sets to 0 if value is null
	# We do this so the beak color changes so it doesn't blend in to camel sprite or sand tiles depending on situation
	bird_sprite.frame = (value != null)
	
	var old_value := camel
	camel = value
	
	if old_value:
		add_collision_exception_with(old_value)
		await get_tree().create_timer(same_camel_collision_cooldown).timeout
		remove_collision_exception_with(old_value)


func _on_camel_detector_body_entered(body: Node2D) -> void:
	if in_air and body.is_in_group("camel"):
		camel = body
