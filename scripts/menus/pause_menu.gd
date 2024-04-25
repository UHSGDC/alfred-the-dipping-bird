extends BaseMenu



func _back_input() -> void:
	menus.change_menu(menus.NONE, false)
	get_viewport().set_input_as_handled()


func _on_resume_pressed() -> void:
	menus.change_menu(menus.NONE, false)


func _on_options_pressed() -> void:
	menus.change_menu(menus.OPTIONS, false)


func _on_main_menu_pressed() -> void:
	menus.trigger_minigame_kill.emit()
	menus.change_menu(menus.MAIN, false)
