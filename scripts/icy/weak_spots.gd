extends Node2D

signal uncracked_count_changed(new_value: int)

var uncracked_count: int :
	set(value):
		uncracked_count_changed.emit(value)
		uncracked_count = value
		

func _ready() -> void:
	uncracked_count = get_child_count()
	for child in get_children():
		child.cracked_set.connect(_on_cracked_set)
		

func _on_cracked_set(value: bool) -> void:
	if value:
		uncracked_count -= 1
	else:
		uncracked_count += 1


func reset_weakspots() -> void:
	for child in get_children():
		child.freeze_over()
		child.freeze_over()
