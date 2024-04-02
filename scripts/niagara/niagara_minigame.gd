extends BaseMinigame

const TOP_LEFT_BOUND: Vector2 = Vector2(0, 0)
const BOT_RIGHT_BOUND: Vector2 = Vector2(300, 160)

## The length of the minigame
@export var minigame_time: float
@export var gush_indicator_scene: PackedScene
@export var obstacle_indicator_scene: PackedScene
@export var fish_indicator_scene: PackedScene

@onready var hud: CanvasLayer = $HUD


func _spawn_gush() -> void:
	var rand_x = randf_range(TOP_LEFT_BOUND.x, BOT_RIGHT_BOUND.x)
	_spawn_falling_object(gush_indicator_scene, Vector2(rand_x, -200))


func _spawn_falling_object(indicator_scene: PackedScene, object_pos: Vector2) -> void:
	# Create indicator and initialize (flashing and creating object)
	var indicator: Sprite2D = indicator_scene.instantiate()
	hud.add_child(indicator)
	var object: RigidBody2D = await indicator.initialize(object_pos)
	# Add object to scene and set position
	add_child(object)
	object.position = object_pos
	# Delete indicator
	indicator.queue_free()

