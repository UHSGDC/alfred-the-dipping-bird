extends AudioStreamPlayer


func _on_sound_button_mouse_entered() -> void:
	if !get_parent().disabled:
		play()
