extends Node2D

const scroll_speed: float = 400.0
const scroll_acceleration: float = scroll_speed * 6

func _physics_process(delta: float) -> void:
	position.x -= scroll_speed * delta
