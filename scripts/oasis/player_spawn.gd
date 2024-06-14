extends Path2D


func get_random_point() -> Vector2:
	$PathFollow2D.progress_ratio = randf()
	
	return $PathFollow2D.global_position
