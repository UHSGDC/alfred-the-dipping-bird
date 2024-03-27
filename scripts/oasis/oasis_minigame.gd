extends BaseMinigame


func _on_player_player_killed() -> void:
	end_minigame(false, 0)


func _on_oasis_oasis_reached() -> void:
	end_minigame(true, $Player.current_water)
