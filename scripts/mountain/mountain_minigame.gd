extends BaseMinigame

func _on_player_lost() -> void:
	end_minigame(0, "player lost")

func _on_player_won(coins: int) -> void:
	end_minigame(coins, "player win coins: %s" % coins)
