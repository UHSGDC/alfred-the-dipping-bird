extends RigidBody2D

func _ready() -> void:
	$AnimationPlayer.play("flash")


func kill() -> void:
	$DeathParticles.emitting = true
	$Sprite2D.hide()
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	await $DeathParticles.finished
	queue_free()
	


func _on_body_entered(_body: Node) -> void:
	kill()
