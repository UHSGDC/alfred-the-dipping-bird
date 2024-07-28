class_name TutorialManager extends CanvasLayer

signal tutorial_finished


func _ready() -> void:
	for child in get_children():
		child.hide()
	

func play_tutorial(level: Game.Level) -> void:
	match level:
		Game.Level.MIDWEST:
			$Midwest.display()
		Game.Level.CHICAGO:
			$Chicago.display()
		Game.Level.NIAGARA:
			$Niagara.display()
		Game.Level.ICY:
			$Icy.display()
		_:
			tutorial_finished.emit()


func kill_tutorial() -> void:
	for child in get_children():
		child.hide()


func _on_tutorial_finished() -> void:
	tutorial_finished.emit()
