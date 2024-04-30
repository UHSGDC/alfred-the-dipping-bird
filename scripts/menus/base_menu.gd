class_name BaseMenu extends Control

var menus: Menus

func _input(event: InputEvent) -> void:
	if !visible or !menus:
		return
	
	if menus.current_menu != menus.RESULTS and menus.current_menu != menus.MAIN and menus.current_menu != menus.NONE and event.is_action_pressed("pause"):
		_back_input()


func _back_input() -> void:
	menus.change_menu(menus.previous_menu, false)
	get_viewport().set_input_as_handled()
