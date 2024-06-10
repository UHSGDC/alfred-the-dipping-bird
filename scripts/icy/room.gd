extends Area2D

@export var camera: Camera2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and camera:
		camera.position = position
		body.global_position = get_start_pos()
		$Gate.process_mode = Node.PROCESS_MODE_INHERIT


func get_start_pos() -> Vector2:
	return $Start.global_position
	
