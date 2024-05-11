class_name CutsceneManager extends Node

signal cutscene_finished

var current_cutscene
var is_playing: bool = false


func play_cutscene(level: Game.Level) -> void:
	$CutsceneImitator.paused = false
	$CutsceneImitator.start()
	print("PLACEHOLDER: cutscene playing")
	is_playing = true


func unpause_cutscene() -> void:
	$CutsceneImitator.paused = false
	print("PLACEHOLDER: cutscene unpaused")
	is_playing = true


func pause_cutscene() -> void:
	$CutsceneImitator.paused = true
	print("PLACEHOLDER: cutscene paused")
	is_playing = false


func kill_cutscene() -> void:
	$CutsceneImitator.stop()
	print("PLACEHOLDER: cutscene killed")
	is_playing = false


func _on_cutscene_finished() -> void:
	print("PLACEHOLDER: cutscene finished")
	cutscene_finished.emit()
