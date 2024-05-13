extends Timer

@export var starting_max_time: float
@export var starting_min_time: float
@export var time_reduction: float

var max_time: float
var min_time: float
var total_spawns: int = 0


func start_spawn_timer() -> void:
	max_time = starting_max_time
	min_time = starting_min_time
	start(randf_range(min_time / 4, max_time / 4)) # Divide by 4 to start sooner


func _on_timeout() -> void:
	total_spawns += 1
	if max_time > min_time:
		max_time -= time_reduction
	start(randf_range(min_time, max_time))
