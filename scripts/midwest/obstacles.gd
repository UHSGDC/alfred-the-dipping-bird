extends Node2D

@export var scrolling_background: Node2D

func _ready() -> void:
	var scroll_speed: float = scrolling_background.scroll_speed
	for child in get_children():
		child.linear_velocity.x -= scroll_speed
