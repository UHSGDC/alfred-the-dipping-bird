extends TextureRect

const AUTOSCROLL_SPEED: float = 15.0
const FINISH: float = -470

signal scroll_finished

var scrolling: bool = false

func _process(delta: float) -> void:
	if position.y <= FINISH:
		scroll_finished.emit()
		scrolling = false
	if scrolling:
		position.y -= AUTOSCROLL_SPEED * delta


func _input(event: InputEvent) -> void:
	if !scrolling:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			position.y -= event.factor * AUTOSCROLL_SPEED
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			position.y += event.factor * AUTOSCROLL_SPEED


func start_scrolling() -> void:
	scrolling = true
