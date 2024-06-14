extends StaticBody2D


func _on_player_bounds_hit() -> void:
	$AnimationPlayer.play("show")


func _on_player_bounds_left() -> void:
	$AnimationPlayer.play("hide")
