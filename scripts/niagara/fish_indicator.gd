extends Sprite2D

const fish_scene: PackedScene = preload("res://scenes/niagara/fish.tscn")

func initialize(obstacle_pos: Vector2) -> RigidBody2D:
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished
	var fish: RigidBody2D = fish_scene.instantiate()
	return fish
	
