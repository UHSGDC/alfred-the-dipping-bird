extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var inital_sprite_scale: Vector2 = sprite.scale
@onready var inital_shape_size: Vector2 = collision_shape.shape.size

func _ready() -> void:
	# Makes sure that each obstacle has its own unique collision shape
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = inital_shape_size

## Scales the obstacle's sprite and collision shape by the value given. A value of 1 will set the scale to the initial. This may need a more permanent solution to deal with other shapes besides rectangles
func set_obstacle_scale(value: float) -> void:
	sprite.scale = inital_sprite_scale * value
	collision_shape.shape.size = inital_shape_size * value
