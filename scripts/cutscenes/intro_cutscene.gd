extends Cutscene

@onready var controller: Control = $Controller

func _ready() -> void:
	if get_tree().root.get_child(1) == self:
		controller.play()


func play() -> void:
	controller.process_mode = Node.PROCESS_MODE_INHERIT
	controller.show()
	controller.play()


func pause() -> void:
	controller.process_mode = Node.PROCESS_MODE_DISABLED
	

func unpause() -> void:
	controller.process_mode = Node.PROCESS_MODE_INHERIT
	
	
func kill() -> void:
	controller.process_mode = Node.PROCESS_MODE_DISABLED
	controller.hide()
	controller.skip_input = true

func _on_controller_finished() -> void:
	controller.hide()
	finished.emit()
