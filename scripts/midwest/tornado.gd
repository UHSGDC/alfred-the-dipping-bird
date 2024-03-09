extends Area2D

@export var path: Path2D
## Speed in pixels
@export var path_follow_speed: float

## The value that the linear velocity is multiplied by to get the impulse that is applied on the body when the tornado releases that body
@export var force_vel_multiplier: float = 1.0
@export var torque_vel_multiplier: float = 20
## Time before an additional force is applied on the object (in ms)
@export var time_before_force: float = 1000

# Pixel offset
var current_path_offset: float = 0
var pulled_objects: Array[PulledObstacle]


#func _ready() -> void:
	#var obs: PulledObstacle = PulledObstacle.new(RigidBody2D.new())
	#print(obs.time_created)


func _physics_process(delta: float) -> void:
	if path:
		current_path_offset += path_follow_speed * delta
		global_position = path.curve.sample_baked(current_path_offset) + path.global_position
	for object in pulled_objects:
		object.body.apply_torque(object.body.linear_velocity.length() * torque_vel_multiplier)
		if object.get_time_since_pulled() > time_before_force:
			var perpindicular_to_tangent: Vector2 = global_position.direction_to(object.body.global_position)
			var tangent: Vector2 = perpindicular_to_tangent.rotated(PI / 2) # rotate that by 90 to get tangent
			object.body.apply_central_force(tangent * object.body.linear_velocity.length() * force_vel_multiplier)


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		pulled_objects.append(PulledObstacle.new(body))


func _on_body_exited(body: Node2D) -> void:
	for i in pulled_objects.size():
		if pulled_objects[i].body == body:
			pulled_objects.remove_at(i)
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
