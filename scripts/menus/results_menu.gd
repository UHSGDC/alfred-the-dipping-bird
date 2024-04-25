extends BaseMenu

var score_info: String : 
	set(value):
		score_info = value
		$VBoxContainer/ScoreInfo.text = score_info
	
var score: int : 
	set(value):
		score = value
		$VBoxContainer/Score.text = str(score)
		$VBoxContainer/Result.text = "Win" if score > 0 else "Lose"
		$VBoxContainer/HBoxContainer/Next.text = "Next" if score > 0 else "Skip"


func _on_retry_pressed() -> void:
	menus.retry_pressed.emit()
	menus.change_menu(menus.NONE, true)


func _on_next_pressed() -> void:
	menus.next_pressed.emit()
	menus.change_menu(menus.NONE, true)


func _on_main_menu_pressed() -> void:
	menus.change_menu(menus.MAIN, false)
