class_name Menus extends CanvasLayer

# Originate in this class
signal menu_opened
signal menu_closed

# Originate in one of the menus that are a child of this
signal play_pressed
signal level_selected(level: Game.Level)
signal next_pressed
signal retry_pressed
signal trigger_minigame_kill
signal show_tutorial


enum {
	MAIN,
	CREDITS,
	PAUSE,
	OPTIONS,
	LEVEL_SELECT,
	RESULTS,
	NONE,
}

var current_menu: int = NONE
var previous_menu: int = NONE


func _ready() -> void:
	show()
	
	for child in get_children():
		child.menus = self
	
	change_menu.call_deferred(MAIN, false)


# If signal_emitted is true the signals menu_closed and menu_opened will not be triggered
func change_menu(new_menu: int, signal_emitted: bool) -> void:
	for child in get_children():
		child.hide()
	
	match new_menu:
		MAIN:
			$MainMenu.show()
		CREDITS:
			$CreditsMenu.show()
		PAUSE:
			$PauseMenu.show()
		OPTIONS:
			$OptionsMenu.show()
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


func credits_to_main() -> void:
	#print("h")
	var tween := get_tree().create_tween()
	
	tween.tween_property($CreditsMenu, "modulate", Color.TRANSPARENT, 3)
	
	$MainMenu.show()
	$MainMenu.modulate = Color.TRANSPARENT
	tween.parallel().tween_property($MainMenu, "modulate", Color.WHITE, 3)
	await tween.finished
	
	$CreditsMenu.hide()
	$CreditsMenu.modulate = Color.WHITE
	menu_opened.emit()
	previous_menu = current_menu
	current_menu = MAIN
	
	
func none_to_credits() -> void:
	previous_menu = current_menu
	current_menu = CREDITS
	
	var tween := get_tree().create_tween()
	
	$CreditsMenu.fading_in = true
	$CreditsMenu.show()
	$CreditsMenu.modulate = Color.TRANSPARENT
	tween.tween_property($CreditsMenu, "modulate", Color.WHITE, 3)
	await tween.finished
	$CreditsMenu.perform_show_action()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_menu == PAUSE:
			change_menu(NONE, false)
		elif current_menu == NONE:
			change_menu(PAUSE, false)


func _on_minigame_manager_minigame_ended(score: int, score_info: String) -> void:
	$ResultsMenu.score = score
	if score_info:
		$ResultsMenu.score_info = score_info
	change_menu(RESULTS, false)
