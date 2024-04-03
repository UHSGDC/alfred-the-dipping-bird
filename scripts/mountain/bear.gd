extends RigidBody2D

@export_enum("Up", "Left", "Right") var direction: String = "Up"
@export var base_speed: float = 500

func _ready() -> void:
	linear_velocity = Vector2.ZERO
	if direction == "Up":
		linear_velocity.y = -base_speed
	elif direction == "Left":
		linear_velocity.x = -base_speed
	elif direction == "Right":
		linear_velocity.x = base_speed

func kill() -> void:
	$Sprite2D.hide()
	queue_free()

func _on_body_entered(_body: Node) -> void:
	kill()
