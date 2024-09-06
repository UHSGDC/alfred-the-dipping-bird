class_name CutsceneManager extends Node

const INTRO = preload("res://scenes/cutscenes/intro_cutscene.tscn")
const DIPPING = preload("res://scenes/cutscenes/dipping_cutscene.tscn")
const END = preload("res://scenes/cutscenes/end_cutscene.tscn")

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
		child.queue_free()


func play_cutscene(level: Game.Level, type: Type) -> void:
	kill_all()
	match type:
		Type.DIPPING:
			current_cutscene = DIPPING.instantiate()
			current_cutscene.finished.connect(_on_dipping_cutscene_finished)
		Type.INTRO:
			current_cutscene = INTRO.instantiate()
			current_cutscene.finished.connect(_on_intro_cutscene_finished)
		Type.END:
			current_cutscene = END.instantiate()
			current_cutscene.finished.connect(_on_end_cutscene_finished)
	add_child(current_cutscene)
	current_cutscene.play.call_deferred()
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
		current_cutscene.queue_free()
		current_cutscene = null
	is_playing = false


func _on_dipping_cutscene_finished() -> void:
	dipping_finished.emit()


func _on_intro_cutscene_finished() -> void:
	intro_finished.emit()


func _on_end_cutscene_finished() -> void:
	end_finished.emit()
