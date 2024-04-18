extends TextureRect

var max_x: int = 0


func _ready() -> void:
	max_x = $ParticleProgress.size.x
	$ParticleProgress.size.x = 0
	
	
func update_meter(current_wetness: float, max_wetness: float) -> void:
	# Add 5 to max_x to make the progress be a little more than it actually is
	$ParticleProgress.size.x = current_wetness / max_wetness * (max_x + 5)
