## For all intensive purposes, the parent script that is referred to several times is a script/node that this minigame scene/script will be a child of. You do not need to worry about the parent script and how it works as this will be something Nick will implement. You need to implement gameplay. Please use _ready() to initialize anything that needs to be initialized like signals. The parent script will implement a way to start and pause the game by changing the process mode.
class_name BaseMinigame extends Node2D

## This signal should be emitted when the game is over whether it is a win or loss. If it is loss then the score should also be 0.
signal minigame_ended(score: int, score_info: String)

## This variable is used to determine whether the game will act in a way to be easily debuggable or if we are in the actual game. This is helpful when the minigame needs to print certain debug messages (implemented by inherited class).
@export var debug_mode: bool = false

## This class has no use for this variable, but you may find it useful. This variable is set to true inside of end_minigame()
var is_minigame_ended: bool = false
# If you feel the need to have a is_minigame_started variable as well, please consult Nick


## Call this function when you want to end the minigame. It will send emit a minigame_ended signal
func end_minigame(score: int, score_info: String) -> void:
	minigame_ended.emit(score, score_info)
	is_minigame_ended = true
