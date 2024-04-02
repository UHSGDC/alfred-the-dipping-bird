extends BaseMinigame

const TOP_LEFT_BOUND: Vector2 = Vector2(0, 0)
const BOT_RIGHT_BOUND: Vector2 = Vector2(300, 160)

@export var gush_indicator_scene: PackedScene
@export var obstacle_indicator_scene: PackedScene
@export var fish_indicator_scene: PackedScene
## The length of the minigame in seconds
@export var minigame_time: float

var fish_collected: int = 0

@onready var hud: CanvasLayer = $HUD
@onready var gush_spawn_left: Marker2D = $GushSpawn/LeftSpawn
@onready var gush_spawn_right: Marker2D = $GushSpawn/RightSpawn
@onready var fish_spawn_left: Marker2D = $FishSpawn/LeftSpawn
@onready var fish_spawn_right: Marker2D = $FishSpawn/RightSpawn
@onready var obstacle_spawn_left: Marker2D = $ObstacleSpawn/LeftSpawn
@onready var obstacle_spawn_right: Marker2D = $ObstacleSpawn/RightSpawn


func _ready() -> void:
	$MinigameTimer.start(minigame_time)
	$ObstacleTimer.start_spawn_timer()
	await get_tree().create_timer(1).timeout
	$FishTimer.start_spawn_timer()
	await get_tree().create_timer(1).timeout
	$GushTimer.start_spawn_timer()
	


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



func _on_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("fish"):
		fish_collected += 1
		if debug_mode:
			print(str(fish_collected) + " fish collected")
	elif body.is_in_group("obstacle"):
		end_minigame(false, 0)
		if debug_mode:
			print("player hit obstacle")
			
	if body.is_in_group("breakable"):
		body.queue_free()


func _on_obstacle_timer_timeout() -> void:
	var rand_x := randf_range(obstacle_spawn_left.position.x, obstacle_spawn_right.position.x)
	_spawn_falling_object(obstacle_indicator_scene, Vector2(rand_x, obstacle_spawn_left.position.y))


func _on_gush_timer_timeout() -> void:
	var rand_x := randf_range(gush_spawn_left.position.x, gush_spawn_right.position.x)
	_spawn_falling_object(gush_indicator_scene, Vector2(rand_x, gush_spawn_left.position.y))


func _on_fish_timer_timeout() -> void:
	var rand_x := randf_range(fish_spawn_left.position.x, fish_spawn_right.position.x)
	_spawn_falling_object(fish_indicator_scene, Vector2(rand_x, fish_spawn_left.position.y))


func _on_minigame_timer_timeout() -> void:
	end_minigame(true, fish_collected)
