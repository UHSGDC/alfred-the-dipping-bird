class_name Tutorial extends Panel

signal tutorial_finished

var current_description_index: int
var desc_count: int

@onready var descriptions: Control = $Descriptions
@onready var start: Button = $Start
@onready var back: Button = $Back

func _ready() -> void:
	desc_count = descriptions.get_child_count()
	show_description(0)
	display()


func display() -> void:
	if desc_count == 0:
		return
	show()
	$Back.hide()
	current_description_index = 0
	if desc_count > 1:
		start.text = "Next"
	else:
		start.text = "Start"


func _on_back_pressed() -> void:
	if current_description_index > 0:
		current_description_index -= 1
		show_description(current_description_index)
		if current_description_index < desc_count - 1:
			start.text = "Next"
	if current_description_index == 0:
		back.hide()


func _on_start_pressed() -> void:
	if current_description_index + 1 < desc_count:
		current_description_index += 1
		show_description(current_description_index)
		if current_description_index == desc_count - 1:
			start.text = "Start"
		if current_description_index > 0:
			back.show()
	else:
		tutorial_finished.emit()


func show_description(index: int) -> void:
	hide_descriptions()
	descriptions.get_child(index).show()

func hide_descriptions() -> void:
	for child in descriptions.get_children():
		child.hide()
