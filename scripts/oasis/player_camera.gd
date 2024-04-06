extends Camera2D

@export var player: CharacterBody2D
@export var max_offset: Vector2 = Vector2(60, 50)
@export var offset_tween_duration: float = 1.0
@export var ground_smoothing: float = 1.0
@export var camel_smoothing: float = 2.5

@onready var offset_tween: Tween

func _ready() -> void:
	global_position = player.global_position


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if input != Vector2.ZERO:
		if offset_tween:
			offset_tween.kill()
		offset_tween = create_tween()
		offset_tween.tween_property(self, "offset", max_offset * input, offset_tween_duration)
	elif player.camel:
		if offset_tween:
			offset_tween.kill()
		offset_tween = create_tween()
		offset_tween.tween_property(self, "offset", max_offset * Vector2.from_angle(player.global_rotation), offset_tween_duration)
	
	var smoothing: float = camel_smoothing if player.camel else ground_smoothing
	
	global_position = global_position.lerp(player.global_position, smoothing * delta)
	
	
