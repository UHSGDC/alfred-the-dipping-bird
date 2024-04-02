extends RigidBody2D

@export_enum("Left:-500", "Right:500") var direction: int = 500

func _ready() -> void:
	linear_velocity.x = direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
