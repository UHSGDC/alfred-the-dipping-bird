extends BaseMenu


func _back_input() -> void:
	if $ControlsView.visible:
		$ControlsView.hide()
		get_tree().set_input_as_handled()
		return
		
	super()


func _on_back_pressed() -> void:	
	menus.change_menu(menus.previous_menu, false)
	

func _on_view_controls_pressed() -> void:
	$ControlsView.show()


func _on_music_value_changed(value: int) -> void:
	if !value:
		AudioServer.set_bus_volume_db(1, -80)
		return
		
	AudioServer.set_bus_volume_db(1, -30 + value * 3)


func _on_sound_value_changed(value: int) -> void:
	if !value:
		AudioServer.set_bus_volume_db(2, -80)
		return
		
	AudioServer.set_bus_volume_db(2, -30 + value * 3)


func _on_master_value_changed(value: int) -> void:
	if !value:
		AudioServer.set_bus_volume_db(0, -80)
		return
		
	AudioServer.set_bus_volume_db(0, -30 + value * 3)
