extends BaseMinigame

func _on_player_player_lost() -> void:
	end_minigame(false, 0)

func _on_player_player_won() -> void:
	end_minigame(false, 100)
