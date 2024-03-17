extends BaseMinigame

@export var player: Area2D

func _on_player_lost() -> void:
	print(player.name + " lost")
	end_minigame(false, 0)

func _on_player_won() -> void:
	print(player.name + " won")
	
	# Temporarly made the win reward to be equal to the players health, which goes up to 100
	end_minigame(true, player.health)
