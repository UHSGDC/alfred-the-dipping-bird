extends BaseMinigame

@export var random_spawning: bool = true

func _ready() -> void:
	if random_spawning:
		$Player.global_position = $PlayerSpawn.get_random_point()
		
	$PlayerCamera.global_position = $Player.global_position


func _on_player_player_killed() -> void:
	end_minigame(0, "thirst")
	if debug_mode:
		print("player died of thirst")


func _on_oasis_oasis_reached() -> void:
	end_minigame($Player.current_water, "player wins with %s water" % $Player.current_water)
	if debug_mode:
		print("player reached oasis")
		
