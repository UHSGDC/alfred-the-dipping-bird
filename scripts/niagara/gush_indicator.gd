extends Sprite2D

const GUSH_SCENE: PackedScene = preload("res://scenes/niagara/objects/gush.tscn")

func initialize(obstacle_pos: Vector2) -> RigidBody2D:
	position.x = obstacle_pos.x
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished
	var gush: RigidBody2D = GUSH_SCENE.instantiate()
	return gush
	
