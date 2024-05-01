extends BaseMenu


func _on_back_pressed() -> void:
	menus.change_menu(menus.previous_menu, false)
