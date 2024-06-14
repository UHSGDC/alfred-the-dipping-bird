extends Node

## The minigame that will be tested by the tester
@export var minigame_scene: PackedScene

var minigame: BaseMinigame

func _ready() -> void:
	instance_minigame()


func _input(event: InputEvent) -> void:
	# Some guidelines for testing using these inputs.
	# 1. The game should be unpaused when the minigame is ended
	# 2. The game should be reinstanced once the minigame is ended before unpausing
	# 3. When the game is reinstanced it will be paused by default
	# Note: Reinstancing means deleting the old copy of the minigame and creating a new instance of it.
	if event.is_action_pressed("minigame_tester_reinstance"): # ENTER or R by default
		minigame.queue_free()
		instance_minigame()
	elif event.is_action_pressed("minigame_tester_pause"): # ESC by default
		if minigame.process_mode == Node.PROCESS_MODE_INHERIT:
			minigame.process_mode = Node.PROCESS_MODE_DISABLED
			print("Minigame Tester: Minigame paused via minigame_tester_pause input")
		elif minigame.process_mode == PROCESS_MODE_DISABLED:
			minigame.process_mode = Node.PROCESS_MODE_INHERIT
			print("Minigame Tester: Minigame unpaused via minigame_tester_pause input")
	#elif event.is_action_pressed("minigame_tester_end"): # BACKSPACE by default
		#var win := false
		#var currency_rewarded := 0
		#minigame.end_minigame(win, currency_rewarded)
		#print("Minigame Tester: Minigame ended via minigame_tester_end input")


# Create new minigame and pause it
func instance_minigame() -> void:
	minigame = minigame_scene.instantiate()
	minigame.process_mode = Node.PROCESS_MODE_DISABLED
	minigame.minigame_ended.connect(_on_minigame_ended)
	add_child(minigame)
	print("Minigame Tester: Minigame resintanced in new_minigame()")
	
	
func _on_minigame_ended(win: bool, currency_rewarded: int) -> void:
	minigame.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	print("Minigame Tester: minigame_ended signal recieved into _on_minigame_ended with arguments win = %s and currency rewarded = %s" % [win, currency_rewarded])
