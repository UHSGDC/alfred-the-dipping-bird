extends RigidBody2D

@export var speed: float = 500

func _physics_process(delta):
	global_position += Vector2(-speed, 0).rotated(rotation) * delta
