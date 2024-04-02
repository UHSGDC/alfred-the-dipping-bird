extends RigidBody2D

@export_enum("Up", "Left", "Right") var direction: String = "Up"

func _ready() -> void:
	if direction == "Up":
		linear_velocity.y = -350
	elif direction == "Left":
		linear_velocity.x = -350
	elif direction == "Right":
		linear_velocity.x = 350

func kill() -> void:
	$Sprite2D.hide()
	queue_free()

func _on_body_entered(_body: Node) -> void:
	kill()
