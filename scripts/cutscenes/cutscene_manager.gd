class_name CutsceneManager extends Node

enum Type {
	DIPPING,
	INTRO,
	END,
}

signal dipping_finished
signal intro_finished
signal end_finished

var current_cutscene: Cutscene
var is_playing: bool = false

func kill_all() -> void:
	for child in get_children():
		child.kill()


func play_cutscene(level: Game.Level, type: Type) -> void:
	match type:
		Type.DIPPING:
			current_cutscene = $DippingCutscene
		Type.INTRO:
			current_cutscene = $IntroCutscene
		Type.END:
			current_cutscene = $EndCutscene
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
		current_cutscene = null
	is_playing = false


func _on_dipping_cutscene_finished() -> void:
	dipping_finished.emit()


func _on_intro_cutscene_finished() -> void:
	intro_finished.emit()


func _on_end_cutscene_finished() -> void:
	end_finished.emit()
