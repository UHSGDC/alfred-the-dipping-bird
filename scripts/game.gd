class_name Game extends Node

enum Level {
	MIDWEST,
	CHICAGO,
	NIAGARA,
	ICY,
	JAPAN,
}

var cutscene_playing: bool = false
var tutorial_playing: bool = false

var intro_cutscene_played: bool = false
var end_cutscene_played: bool = false

var tutorial_played: Dictionary = {
	Level.MIDWEST : false,
	Level.CHICAGO : false,
	Level.NIAGARA : false,
	Level.ICY : false,
	Level.JAPAN : false
}

var current_level: Level = Level.MIDWEST

@onready var menus: Menus = $Menus
@onready var minigame_manager: MinigameManager = $MinigameManager
@onready var cutscene_manager: CutsceneManager = $CutsceneManager
@onready var tutorial_manager: TutorialManager = $TutorialManager


func _ready() -> void:
	MusicManager.play_track(MusicManager.Track.TITLE)
	cutscene_manager.kill_all()


func play_current_level() -> void:
	minigame_manager.kill_minigame()
	cutscene_playing = false
	cutscene_manager.kill_cutscene()
	minigame_manager.play_minigame(current_level)
	minigame_manager.pause_minigame()
	if current_level == Level.MIDWEST && !intro_cutscene_played:
		MusicManager.fade_to_track(MusicManager.Track.NONE)
		cutscene_playing = true
		cutscene_manager.play_cutscene(Level.MIDWEST, CutsceneManager.Type.INTRO)
	else:
		MusicManager.fade_to_track(current_level + 1)
		if tutorial_played[current_level]:
			minigame_manager.play_minigame(current_level)
			return
		tutorial_playing = true
		tutorial_manager.play_tutorial(current_level)


func _on_menus_level_selected(level: Game.Level) -> void:
	current_level = level
	play_current_level()


func _on_menus_menu_closed() -> void:
	if cutscene_playing:
		cutscene_manager.unpause_cutscene()
	elif tutorial_playing:
		pass
	else:
		minigame_manager.unpause_minigame()

func _on_menus_menu_opened() -> void:
	minigame_manager.pause_minigame()
	cutscene_manager.pause_cutscene()


func _on_menus_next_pressed() -> void:
	cutscene_playing = true
	cutscene_manager.play_cutscene(current_level, CutsceneManager.Type.DIPPING)


func _on_menus_play_pressed() -> void:
	play_current_level()


func _on_menus_retry_pressed() -> void:
	play_current_level()


func _on_menus_trigger_minigame_kill() -> void:
	minigame_manager.kill_minigame()
	cutscene_playing = false
	cutscene_manager.kill_cutscene()
	MusicManager.fade_to_track(MusicManager.Track.TITLE)


func _on_cutscene_manager_dipping_finished() -> void:
	cutscene_playing = false
	current_level = (current_level + 1) as Level # Sets current level to next level. Assumes the levels enum has the levels in order
	if current_level < Level.size():
		tutorial_played[current_level] = false
		play_current_level()
	else:
		current_level = 0
		cutscene_playing = true
		cutscene_manager.play_cutscene(0, CutsceneManager.Type.END)
		MusicManager.fade_to_track(MusicManager.Track.END)


func _on_cutscene_manager_intro_finished() -> void:
	MusicManager.fade_to_track(current_level + 1)
	cutscene_playing = false
	cutscene_manager.kill_cutscene.call_deferred()
	intro_cutscene_played = true
	tutorial_playing = true
	tutorial_manager.play_tutorial(current_level)


func _on_tutorial_manager_tutorial_finished() -> void:
	tutorial_playing = false
	tutorial_manager.kill_tutorial.call_deferred()
	tutorial_played[current_level] = true
	minigame_manager.unpause_minigame()


func _on_cutscene_manager_end_finished() -> void:
	cutscene_playing = false
	menus.none_to_credits.call_deferred()


func _on_menus_show_tutorial() -> void:
	minigame_manager.pause_minigame()
	tutorial_playing = true
	tutorial_manager.play_tutorial(current_level)
	
