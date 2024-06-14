extends BaseMinigame

func _on_player_lost() -> void:
	end_minigame(false, 0)

func _on_player_won(coins: int) -> void:
	end_minigame(true, coins)
