extends BaseMinigame

@export var player: Area2D

@onready var this_node = get_node(".")

func _on_player_lost() -> void:
	end_minigame(false, 0)

func _on_player_won() -> void:
	end_minigame(true, player.health)

func _on_minigame_ended(win, currency_reward):
	if this_node.debug_mode == true:
		if win == true:
			print(player.name + " won")
		if win == false:
			print(player.name + " lost")
		print("The reward is " + str(currency_reward))
	get_tree().reload_current_scene()
