extends ColorRect

signal fade_done

@export var fade_in_time: float
## Time for black screen to fade out
@export var fade_out_time: float


# Shows black screen
func fade_in() -> void:
	fade(Color.WHITE, fade_in_time)
	

# Hides black screen
func fade_out() -> void:
	fade(Color.TRANSPARENT, fade_in_time)


func fade(final_val: Color, time: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", final_val, time)
	await tween.finished
	fade_done.emit()
