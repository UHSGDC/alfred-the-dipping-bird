extends StaticBody2D


@onready var col_shape: CollisionShape2D = $CollisionShape2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.position.y < position.y:
			z_index = 2 # Place above player if this dune is below the player
			col_shape.set_deferred("disabled", false)
		else:
			z_index = 0
			col_shape.set_deferred("disabled", true)


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.position.y < position.y:
			z_index = 2 # Place above player if this dune is below the player
			col_shape.set_deferred("disabled", false)
		else:
			z_index = 0
			col_shape.set_deferred("disabled", true)
