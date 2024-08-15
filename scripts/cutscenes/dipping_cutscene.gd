extends Cutscene


func play() -> void:
	$Path2D.modulate = Color.WHITE
	$Water.modulate = Color.WHITE
	$AnimationPlayer.play("dip")
	await $AnimationPlayer.animation_finished
	finished.emit()


func pause() -> void:
	$AnimationPlayer.pause()


func unpause() -> void:
	$AnimationPlayer.play()


func kill() -> void:
	$Path2D.modulate = Color.TRANSPARENT
	$Water.modulate = Color.TRANSPARENT
	$AnimationPlayer.stop()
