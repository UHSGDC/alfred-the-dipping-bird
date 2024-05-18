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

var current_level: Level = Level.MIDWEST

@onready var menus: Menus = $Menus
@onready var minigame_manager: MinigameManager = $MinigameManager
@onready var cutscene_manager: CutsceneManager = $CutsceneManager

func _ready() -> void:
	MusicManager.play_track(0)
	cutscene_manager.kill_all()


func play_current_level() -> void:
	minigame_manager.kill_minigame()
	cutscene_manager.kill_cutscene()
	MusicManager.fade_to_track(current_level + 1)
	#if cutscene_played[current_level]:
		#minigame_manager.play_minigame(current_level)
		#return
	#cutscene_manager.play_cutscene(current_level, true)
	minigame_manager.play_minigame(current_level)
	# The rest of this method continues after the minigame finishes in the _on_cutscene finished method


func _on_menus_level_selected(level: Game.Level) -> void:
	current_level = level
	play_current_level()


func _on_menus_menu_closed() -> void:
	minigame_manager.unpause_minigame()
	cutscene_manager.unpause_cutscene()


func _on_menus_menu_opened() -> void:
	minigame_manager.pause_minigame()
	cutscene_manager.pause_cutscene()


func _on_menus_next_pressed() -> void:
	cutscene_manager.play_cutscene(current_level, true)


func _on_menus_play_pressed() -> void:
	play_current_level()


func _on_menus_retry_pressed() -> void:
	play_current_level()


func _on_menus_trigger_minigame_kill() -> void:
	minigame_manager.kill_minigame()
	cutscene_manager.kill_cutscene()
	MusicManager.fade_to_track(0)


func _on_cutscene_manager_dipping_finished() -> void:
	current_level = (current_level + 1) as Level # Sets current level to next level. Assumes the levels enum has the levels in order
	if current_level < Level.size():
		play_current_level()
	else:
		menus.change_menu.call_deferred(Menus.CREDITS, false)
		MusicManager.fade_to_track(MusicManager.Track.TITLE)


func _on_cutscene_manager_intro_finished() -> void:
	cutscene_manager.kill_cutscene.call_deferred()
	cutscene_played[current_level] = true
	minigame_manager.play_minigame(current_level)
