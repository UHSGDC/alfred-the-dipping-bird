extends Node2D

@export var scroll_speed: float = 700.0
@export var scroll_acceleration: float = scroll_speed * 6 # for slowing and stoppping the scrolling.

func _physics_process(delta: float) -> void:
	position.x -= scroll_speed * delta
