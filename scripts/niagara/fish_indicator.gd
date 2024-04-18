extends Sprite2D

const FISH_SCENE: PackedScene = preload("res://scenes/niagara/objects/fish.tscn")

func initialize(obstacle_pos: Vector2) -> RigidBody2D:
	position.x = obstacle_pos.x
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished
	var fish: RigidBody2D = FISH_SCENE.instantiate()
	return fish
	
