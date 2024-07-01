extends Node2D


func _ready() -> void:
	for child in get_children():
		child.frame = randi_range(0, 3)
