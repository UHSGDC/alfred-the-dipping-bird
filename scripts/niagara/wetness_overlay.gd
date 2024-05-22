extends ColorRect

const overlay_start: float = 0.5

func _ready() -> void:
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0.3), 0.3)
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.3)


func _on_player_wetness_changed(current_wetness: float, max_wetness: float) -> void:
	modulate.a = remap(clampf(current_wetness, max_wetness * overlay_start, max_wetness), max_wetness * overlay_start, max_wetness, 0, 1)
	
