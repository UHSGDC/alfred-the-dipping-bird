extends Area2D

const SCREEN_SHAKE_TIME: float = 0.8

@export var camera: Camera2D	

var cracked: bool = false

var screen_shake: bool = false

var player: CharacterBody2D


func _process(_delta: float) -> void:
	if screen_shake:
		camera.position = position + Vector2.RIGHT.rotated(randf_range(-PI, PI))
	if cracked:
		for area in $Ice.get_overlapping_areas():
			if area.is_in_group("player") and !player.in_air:
				reset()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and camera:
		player = body
		camera.position = position
		player.global_position = get_start_pos()


func get_start_pos() -> Vector2:
	return $Start.global_position


func reset() -> void:
	cracked = false
	var tween := create_tween()
	
	screen_shake = true
	player.falling = true
	player.on_ice = false
	player.in_air = false
	player.splash()
	tween.tween_property(player, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	
	screen_shake = false
	camera.position = position
	
	player.falling = false
	player.scale = Vector2.ONE
	player.global_position = get_start_pos()
	$WeakSpots.reset_weakspots()
	$Water.hide()
	$WeakSpots.show()
	$WeakSpots.process_mode = Node.PROCESS_MODE_INHERIT
	if $CrackGate != null:
		$CrackGate.close()
	


func _on_weak_spots_uncracked_count_changed(new_value: int) -> void:
	if new_value == 0:
		$SplashSound.play()
		screen_shake = true
		$Timer.start(SCREEN_SHAKE_TIME)
		await $Timer.timeout
		screen_shake = false
		camera.position = position
		$SplashParticles.splash()
		$Timer.start(0.1)
		await $Timer.timeout
		cracked = true
		$Water.show()
		$WeakSpots.hide()
		$WeakSpots.process_mode = Node.PROCESS_MODE_DISABLED
		$VictorySound.play()
		if $CrackGate != null:
			$CrackGate.open_animation()
