extends Sprite2D

const BRANCH_SCENE: PackedScene = preload("res://scenes/niagara/objects/branch.tscn")
const ROCK_SCENE: PackedScene = preload("res://scenes/niagara/objects/rock.tscn")
const KAYAK_SCENE: PackedScene = preload("res://scenes/niagara/objects/kayak.tscn")

func initialize(obstacle_pos: Vector2) -> RigidBody2D:
	position.x = obstacle_pos.x
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished
	var obstacle: RigidBody2D = get_random_obstacle_scene().instantiate()
	return obstacle
	
func get_random_obstacle_scene() -> PackedScene:
	var rand := randi_range(0, 8)
	if rand < 4:
		return BRANCH_SCENE
	elif rand < 7:
		return ROCK_SCENE
	else:
		return KAYAK_SCENE
