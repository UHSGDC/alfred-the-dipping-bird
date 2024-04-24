class_name Menus extends CanvasLayer

# Originate in this class
signal menu_opened
signal menu_closed

# Originate in one of the menus that are a child of this
signal play_pressed
signal level_selected(level: Game.Level)
signal next_pressed
signal retry_pressed


enum {
	MAIN,
	CREDITS,
	PAUSE,
	OPTIONS,
	LEVEL_SELECT,
	RESULTS,
	NONE,
}

var current_menu: int
var previous_menu: int


func _ready() -> void:
	show()
	
	for child in get_children():
		child.menus = self
	
	change_menu.call_deferred(MAIN)


func change_menu(new_menu: int, signal_emitted: bool) -> void:
	for child in get_children():
		child.hide.call_deferred()
	
	match new_menu:
		MAIN:
			$MainMenu.show()
		CREDITS:
			$CreditsMenu.show()
		PAUSE:
			$PauseMenu.show()
		OPTIONS:
			$SettingsMenu.show()
		LEVEL_SELECT:
			$LevelSelectMenu.show()
		RESULTS:
			$ResultsMenu.show()
	
	if !signal_emitted:
		if new_menu != NONE and current_menu == NONE:
			menu_opened.emit()
		elif new_menu == NONE and current_menu != NONE:
			menu_closed.emit()
	
	previous_menu = current_menu
	current_menu = new_menu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_menu == PAUSE:
			change_menu(NONE, false)
		elif current_menu == NONE:
			change_menu(PAUSE, false)
