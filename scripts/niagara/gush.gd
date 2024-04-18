extends RigidBody2D


func _on_break_area_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.is_in_group("obstacle") or body.is_in_group("fish"):
		body.queue_free()
