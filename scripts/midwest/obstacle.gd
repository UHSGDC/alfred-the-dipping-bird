extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: Node2D = $CollisionShape2D

## Scales the obstacle's sprite and collision shape by the value given. A value of 1 will set the scale to the initial. This may need a more permanent solution to deal with other shapes besides rectangles
func set_obstacle_scale(value: float) -> void:
	sprite.scale = value * Vector2.ONE
	collision_shape.scale = value * Vector2.ONE
