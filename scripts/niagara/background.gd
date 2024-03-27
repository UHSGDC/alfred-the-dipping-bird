extends ParallaxBackground

@export var scroll_speed: float = 250


func _physics_process(delta: float) -> void:
	scroll_offset.y -= scroll_speed * delta
