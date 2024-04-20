extends BaseMinigame

func _ready() -> void:
	$HUD/ProgressBar.max_value = $WinArea.position.x


func _on_player_player_killed() -> void:
	end_minigame(false, 0)


func _on_win_area_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		return
		
	$HUD/BlackScreen.fade_in()
	await $HUD/BlackScreen.fade_done
	end_minigame(true, $Player.current_lives)


func _process(_delta: float) -> void:
	$HUD/ProgressBar.value = $Player.position.x


func _on_player_lives_changed(new_val: int, max_val: int) -> void:
	$HUD/LivesBar.value = new_val
	$HUD/LivesBar.max_value = max_val
