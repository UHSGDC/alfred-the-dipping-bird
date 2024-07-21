extends Area2D

signal note_hit(score: int)

@export var input_action: StringName

var perfect := false
var good := false
var okay := false
var current_note: Area2D = null


func handle_input() -> void:
	if Input.is_action_just_pressed(input_action):
		$Sprite2D.modulate = Color.WHITE
		$PushTimer.start()
		if current_note != null:
			# Adding up booleans (false = 0, true = 1) instead of having if statements
			var score: int = int(perfect) + int(good) + int(okay)
			note_hit.emit(score)
			current_note.destroy(score)
			_reset()
	elif !Input.is_action_pressed(input_action):
		$Sprite2D.modulate = Color.BLACK


func _on_perfect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = true


func _on_perfect_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = false


func _on_good_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = true


func _on_good_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = false


func _on_okay_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = true
		current_note = area


func _on_okay_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = false
		if current_note == area:
			current_note = null


func _reset() -> void:
	current_note = null
	perfect = false
	good = false
	okay = false


func _on_push_timer_timeout() -> void:
	$Sprite2D.modulate = Color.BLACK
