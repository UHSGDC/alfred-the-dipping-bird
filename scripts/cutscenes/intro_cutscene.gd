extends Cutscene


func play() -> void:
	$DialogBox.process_mode = Node.PROCESS_MODE_INHERIT
	$DialogBox.show()
	$DialogBox.play()


func pause() -> void:
	$DialogBox.process_mode = Node.PROCESS_MODE_DISABLED
	

func unpause() -> void:
	$DialogBox.process_mode = Node.PROCESS_MODE_INHERIT
	
	
func kill() -> void:
	$DialogBox.process_mode = Node.PROCESS_MODE_DISABLED
	$DialogBox.hide()
	$DialogBox.skip_input = true


func _on_dialog_box_finished() -> void:
	$DialogBox.hide()
	finished.emit()
