class_name MinigameManager extends Node

# Originates in the current minigame
signal minigame_ended(score: int, score_info: String)

const MINIGAME_SCENES: Dictionary = {
	Game.Level.MIDWEST : preload("res://scenes/midwest/midwest_minigame.tscn"),
	Game.Level.CHICAGO : preload("res://scenes/chicago/chicago_minigame.tscn"),
	Game.Level.NIAGARA : preload("res://scenes/niagara/niagara_minigame.tscn"),
}

var current_minigame: BaseMinigame
var is_playing: bool = false


func play_minigame(level: Game.Level) -> void:
	if current_minigame:
		kill_minigame()
	current_minigame = MINIGAME_SCENES[level].instantiate()
	add_child(current_minigame)
	current_minigame.minigame_ended.connect(_on_minigame_ended)
	current_minigame.process_mode = Node.PROCESS_MODE_INHERIT
	is_playing = true
	

func pause_minigame() -> void:
	if current_minigame:
		current_minigame.process_mode = Node.PROCESS_MODE_DISABLED
	is_playing = false
	

func unpause_minigame() -> void:
	if current_minigame:
		current_minigame.process_mode = Node.PROCESS_MODE_INHERIT
	is_playing = true


func kill_minigame() -> void:
	if current_minigame:
		current_minigame.queue_free()
		current_minigame = null
	is_playing = false


func _on_minigame_ended(score: int, score_info: String) -> void:
	minigame_ended.emit(score, score_info)
