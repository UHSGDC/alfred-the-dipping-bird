class_name CutsceneManager extends Node

signal cutscene_finished

var current_cutscene
var is_playing: bool = false


func play_cutscene(level: Game.Level) -> void:
	print("PLACEHOLDER: cutscene played")
	is_playing = true
	await get_tree().create_timer(0.5).timeout
	print("PLACEHOLDER: cutscene finished emitted after 0.5 seconds")
	cutscene_finished.emit()
	kill_cutscene.call_deferred()


func unpause_cutscene() -> void:
	print("PLACEHOLDER: cutscene unpaused")
	is_playing = true


func pause_cutscene() -> void:
	print("PLACEHOLDER: cutscene paused")
	is_playing = false


func kill_cutscene() -> void:
	print("PLACEHOLDER: cutscene killed")
	is_playing = false
