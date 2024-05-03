extends BaseMenu


func _on_back_pressed() -> void:
	menus.change_menu(menus.previous_menu, false)
	


func _on_level_select_button_pressed() -> void:
	menus.level_selected.emit(Game.Level.MIDWEST)
	menus.change_menu(Menus.NONE, true)


func _on_level_select_button_2_pressed() -> void:
	menus.level_selected.emit(Game.Level.CHICAGO)
	menus.change_menu(Menus.NONE, true)


func _on_level_select_button_3_pressed() -> void:
	menus.level_selected.emit(Game.Level.NIAGARA)
	menus.change_menu(Menus.NONE, true)
