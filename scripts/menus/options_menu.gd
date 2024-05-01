extends BaseMenu


func _back_input() -> void:
	print("yo")
	if $ControlsView.visible:
		$ControlsView.hide()
		get_tree().set_input_as_handled()
		return
		
	super()

func _on_back_pressed() -> void:	
	menus.change_menu(menus.previous_menu, false)
	

func _on_view_controls_pressed() -> void:
	$ControlsView.show()
