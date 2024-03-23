extends CharacterBody2D

@export var max_ground_speed: float
@export var max_air_speed: float
@export var ground_acceleration: float
@export var air_acceleration_multiplier: float

@export var max_jump_scale: float
@export var jump_time: float
@export var fall_time: float

var in_air: bool = false
var camel: Area2D

@onready var bird_sprite: Sprite2D = $BirdSprite
@onready var anim_play: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if camel:
		camel_move()
	else:
		move(delta, input)
	look(input)
	animate()
	
	if !in_air and Input.is_action_just_pressed("interact"):
		jump()
	
	
func look(input: Vector2) -> void:
	if input != Vector2.ZERO:
		rotation = input.angle()
	elif camel:
		rotation = camel.rotation


func jump() -> void:
	in_air = true
	anim_play.play("jump")
	await anim_play.animation_finished
	in_air = false


func animate() -> void:
	if in_air:
		anim_play.play("jump")
	elif velocity == Vector2.ZERO:
		anim_play.play("idle")
	else:
		anim_play.play("walk")
		

func camel_move() -> void:
	position = camel.player_pos


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


func _on_camel_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("camel"):
		camel = area
