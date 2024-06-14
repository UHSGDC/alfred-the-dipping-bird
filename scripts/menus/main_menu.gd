extends BaseMenu


func _on_play_pressed() -> void:
	menus.play_pressed.emit()
	menus.change_menu(Menus.NONE, true)


func _on_level_select_pressed() -> void:
	menus.change_menu(Menus.LEVEL_SELECT, false)


func _on_options_pressed() -> void:
	menus.change_menu(Menus.OPTIONS, false)


func _on_credits_pressed() -> void:
	menus.change_menu(Menus.CREDITS, false)


func _on_quit_pressed() -> void:
	get_tree().quit()
