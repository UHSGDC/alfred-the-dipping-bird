extends BaseMinigame

func _on_player_lost() -> void:
	end_minigame(false, 0)

func _on_player_won(lives: int, coins: int) -> void:
	end_minigame(true, lives + coins)
