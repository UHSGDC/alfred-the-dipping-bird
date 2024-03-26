extends Area2D

signal oasis_reached


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		oasis_reached.emit()
