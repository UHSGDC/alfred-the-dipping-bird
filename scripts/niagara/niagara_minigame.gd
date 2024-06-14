extends BaseMinigame

signal lives_changed(lives: int)

const LIFE_SCORE_MULTIPLIER: int = 500
const DESTROY_PARTICLES: PackedScene = preload("res://scenes/midwest/destroy_particles.tscn")
const TOP_LEFT_BOUND: Vector2 = Vector2(0, 0)
const BOT_RIGHT_BOUND: Vector2 = Vector2(300, 160)

@export var gush_indicator_scene: PackedScene
@export var obstacle_indicator_scene: PackedScene
@export var fish_indicator_scene: PackedScene
## The length of the minigame in seconds
@export var minigame_time: float
@export var max_lives: int = 3

var current_lives: int :
	set(value):
		lives_changed.emit(value)
		current_lives = min(value, max_lives)
		$HUD/LivesBar.value = current_lives
		$HUD/LivesBar.max_value = max_lives
		if value <= 0:
			_stop_game()
			await player.kill()
			if value == -10:
				end_minigame(0, "Alfred got caught in a gush of water!")
			else:
				end_minigame(0, "Oh no! Alfred lost all his lives!")

@onready var player: Area2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var gush_spawn_left: Marker2D = $GushSpawn/LeftSpawn
@onready var gush_spawn_right: Marker2D = $GushSpawn/RightSpawn
@onready var fish_spawn_left: Marker2D = $FishSpawn/LeftSpawn
@onready var fish_spawn_right: Marker2D = $FishSpawn/RightSpawn
@onready var obstacle_spawn_left: Marker2D = $ObstacleSpawn/LeftSpawn
@onready var obstacle_spawn_right: Marker2D = $ObstacleSpawn/RightSpawn


func _ready() -> void:
	current_lives = max_lives
	$MinigameTimer.start(minigame_time)
	$ObstacleTimer.start_spawn_timer()
	await get_tree().create_timer(1).timeout
	$FishTimer.start_spawn_timer()
	await get_tree().create_timer(1).timeout
	$GushTimer.start_spawn_timer()


func _process(_delta: float) -> void:
	$HUD/ProgressBar.value = (minigame_time - $MinigameTimer.time_left) / minigame_time * 100


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
		if current_lives < max_lives:
			current_lives += 1
		body.queue_free()
		if debug_mode:
			print(str(current_lives) + " lives left")
	elif body.is_in_group("obstacle"):
		if debug_mode:
			print("player hit obstacle")
		if body.is_in_group("gush"):
			current_lives = -10
		elif !player.was_just_hit:
			body.queue_free()
			emit_destroy_particles(player.global_position)
			current_lives -= 1
			player.hit()


func _on_obstacle_timer_timeout() -> void:
	var rand_x := randf_range(obstacle_spawn_left.position.x, obstacle_spawn_right.position.x)
	_spawn_falling_object(obstacle_indicator_scene, Vector2(rand_x, obstacle_spawn_left.position.y))


func _on_gush_timer_timeout() -> void:
	var rand_x := clampf(randf_range(gush_spawn_left.position.x, gush_spawn_right.position.x), $GushSpawn/LeftSpawnBound.position.x, $GushSpawn/RightSpawnBound.position.x)
	_spawn_falling_object(gush_indicator_scene, Vector2(rand_x, gush_spawn_left.position.y))


func _on_fish_timer_timeout() -> void:
	var rand_x := clampf(randf_range(fish_spawn_left.position.x, fish_spawn_right.position.x), $FishSpawn/LeftSpawnBound.position.x, $FishSpawn/RightSpawnBound.position.x)
	_spawn_falling_object(fish_indicator_scene, Vector2(rand_x, fish_spawn_left.position.y))


func _on_minigame_timer_timeout() -> void:
	if debug_mode:
		print("timer finished. Player won")
	var score: int = current_lives * LIFE_SCORE_MULTIPLIER
	end_minigame(score, "%s lives left x %s = %s" % [current_lives, LIFE_SCORE_MULTIPLIER, score])
	

func _on_player_wetness_changed(current_wetness: float, max_wetness: float) -> void:
	if current_wetness >= max_wetness:
		if debug_mode:
			print("player got too wet")
		_stop_game()
		await player.fall()
		current_lives = 0
		end_minigame(0, "Alfred soaked with water and fell! If only he hadn't flown over the waterfall for so long...")


func _stop_game() -> void:
	$FishTimer.stop()
	$GushTimer.stop()
	$ObstacleTimer.stop()
	$MinigameTimer.paused = true


func emit_destroy_particles(global_pos: Vector2) -> void:
	var particles: CPUParticles2D = DESTROY_PARTICLES.instantiate()
	particles.emitting = true
	add_child(particles)
	particles.global_position = global_pos
	await particles.finished
	particles.queue_free()
