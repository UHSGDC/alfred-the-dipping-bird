extends ProgressBar


func _on_player_water_changed(current_water: float, max_water: float) -> void:
	max_value = max_water
	value = current_water
