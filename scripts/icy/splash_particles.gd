extends Node2D

signal finished


func splash() -> void:
	for child in get_children():
		child.restart()


func _on_splash_particle_finished() -> void:
	finished.emit()
