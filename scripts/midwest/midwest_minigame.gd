extends BaseMinigame

const LIFE_SCORE_MULTIPLIER: int = 500

func _ready() -> void:
	$HUD/ProgressBar.max_value = $WinArea.position.x
	$HUD/BlackScreen.fade_out()


func _on_player_player_killed(message: String) -> void:
	end_minigame(0, message)


func _on_win_area_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		return
		
	$HUD/BlackScreen.fade_in()
	await $HUD/BlackScreen.fade_done
	var score: int = $Player.current_lives * LIFE_SCORE_MULTIPLIER
	end_minigame(score, "%s lives left x %s = %s" % [$Player.current_lives, LIFE_SCORE_MULTIPLIER, score])


func _process(_delta: float) -> void:
	$HUD/ProgressBar.value = $Player.position.x


func _on_player_lives_changed(new_val: int, max_val: int) -> void:
	$HUD/LivesBar.value = new_val
	$HUD/LivesBar.max_value = max_val
