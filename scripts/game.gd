class_name Game extends Node

enum Level {
	MIDWEST,
	CHICAGO,
	NIAGARA
}

var cutscene_played: Dictionary = {
	Level.MIDWEST : false,
	Level.CHICAGO : false,
	Level.NIAGARA : false,
}

var current_level: Level

@onready var minigame_manager: MinigameManager = $MinigameManager

func _ready() -> void:
	cutscene_played[Level.CHICAGO] = true
	current_level = Level.CHICAGO
	play_current_level()


func play_current_level() -> void:
	if cutscene_played[current_level]:
		minigame_manager.play_minigame(current_level)
	print("cutscenes aren't implemented yet. Nothing happened")


func _on_menus_level_selected(level: Game.Level) -> void:
	current_level = level
	play_current_level()


func _on_menus_menu_closed() -> void:
	minigame_manager.unpause_minigame()


func _on_menus_menu_opened() -> void:
	minigame_manager.pause_minigame()


func _on_menus_next_pressed() -> void:
	current_level += 1
	play_current_level()


func _on_menus_play_pressed() -> void:
	play_current_level()


func _on_menus_retry_pressed() -> void:
	play_current_level()
