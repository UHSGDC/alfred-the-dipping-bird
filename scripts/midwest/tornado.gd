extends Area2D

@export var path: Path2D
## Speed in pixels
@export var path_follow_speed: float

## Multiplier of force applied tangent to the vector between the tornado center and obstacle.
@export var force_vel_multiplier: float = 1.0

## Minimum scale of obstacles for obstacles in tornado. obstacles are scaled between this value and 1
@export_range(0,1) var minimum_scale: float = 0.5

## Multiplier of (velocity.length_squared() ^ torque_vel_exponent). Changes how much overall torque is applied. Applied after torque_vel_exponent.
@export var torque_vel_multiplier: float = 20

## Exponent that is put on the magnitude of the linear velocity squared. Used in conjunction with torque_vel_multiplier. Change how much velocity impacts the torque. Applied before torque_vel_multiplier.
@export var torque_vel_exponent: float = 0.4

## Time before an additional force is applied on the obstacle (in ms)
@export var time_before_force: float = 1000

# Pixel offset
var current_path_offset: float = 0
var pulled_obstacles: Array[PulledObstacle]

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


#func _ready() -> void:
	#var obs: PulledObstacle = PulledObstacle.new(RigidBody2D.new())
	#print(obs.time_created)


func _physics_process(delta: float) -> void:
	if path:
		current_path_offset += path_follow_speed * delta
		global_position = path.curve.sample_baked(current_path_offset) + path.global_position
	for obstacle in pulled_obstacles:
		# Scale based on proximity to tornado
		var dist := global_position.distance_to(obstacle.body.global_position)
		obstacle.body.set_obstacle_scale(remap(min(dist / collision_shape.shape.radius, 1), 0, 1, minimum_scale, 1))
		
		
		# Rotate obstacle based on its velocity. The decimal number
		obstacle.body.apply_torque(obstacle.body.linear_velocity.length_squared() ** torque_vel_exponent * torque_vel_multiplier)
		# Apply an extra force
		if obstacle.get_time_since_pulled() > time_before_force:
			var perpindicular_to_tangent: Vector2 = global_position.direction_to(obstacle.body.global_position)
			var tangent: Vector2 = perpindicular_to_tangent.rotated(PI / 2) # rotate that by 90 to get tangent
			obstacle.body.apply_central_force(tangent * obstacle.body.linear_velocity.length() * force_vel_multiplier)
		


func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("obstacle"):
		return
	if body is RigidBody2D:
		pulled_obstacles.append(PulledObstacle.new(body))


func _on_body_exited(body: Node2D) -> void:
	if !body.is_in_group("obstacle"):
		return
	for i in pulled_obstacles.size():
		if pulled_obstacles[i].body == body:
			pulled_obstacles[i].body.set_obstacle_scale(1)
			pulled_obstacles.remove_at(i)
			return


# Include RigidBody2D and time it was pulled
class PulledObstacle:
	var body: RigidBody2D
	var time_pulled: float
	func _init(_body: RigidBody2D) -> void:
		time_pulled = Time.get_ticks_msec()
		body = _body
		
	func get_time_since_pulled() -> float:
		return Time.get_ticks_msec() - time_pulled
