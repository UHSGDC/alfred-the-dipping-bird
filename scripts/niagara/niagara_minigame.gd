extends BaseMinigame

const SPAWN_AMOUNT: int = 100

const top_left_bound: Vector2 = Vector2(0, 0)
const bot_right_bound: Vector2 = Vector2(1152, 648)

var spawn_delay: float = 2
var spawn_delay_reduction: float = 0.1

func _ready() -> void:
	randomize()
	for i in range(SPAWN_AMOUNT):
		_spawn_obstacle()
		await _wait(spawn_delay)
		spawn_delay -= spawn_delay_reduction

func _spawn_obstacle() -> void:
	var obstacle = preload("res://scenes/niagara/obstacle.tscn").instantiate()
	var rand_x = randf_range(top_left_bound.x, bot_right_bound.x)
	obstacle.global_position = Vector2(rand_x, -200)
	add_child(obstacle)
	
func _on_player_lost() -> void:
	end_minigame(false, 0)
	
func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
