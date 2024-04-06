extends PathFollow2D

@export var speed_ratio: float = 0.12


func _physics_process(delta: float) -> void:
	progress_ratio += delta * speed_ratio
	
