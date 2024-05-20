class_name CutsceneManager extends Node

signal dipping_finished
signal intro_finished

var current_cutscene: Cutscene
var is_playing: bool = false

func kill_all() -> void:
	for child in get_children():
		child.kill()


func play_cutscene(level: Game.Level, dipping: bool) -> void:
	if dipping:
		current_cutscene = $DippingCutscene
	current_cutscene.play()
	is_playing = true


func unpause_cutscene() -> void:
	if current_cutscene:
		current_cutscene.unpause()
	is_playing = true


func pause_cutscene() -> void:
	if current_cutscene:
		current_cutscene.pause()
	is_playing = false


func kill_cutscene() -> void:
	if current_cutscene:
		current_cutscene.kill()
	is_playing = false


func _on_dipping_cutscene_finished() -> void:
	dipping_finished.emit()
