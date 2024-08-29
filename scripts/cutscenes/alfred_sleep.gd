extends AnimatedSprite2D

func wake_up(num: int) -> void:
	match num:
		1:
			
			while(frame != 4):
				await get_tree().create_timer(0).timeout
				if frame == 3:
					$Snore.stop()
			play("wake_up1")
			$Pop.play()
			await animation_finished
		2:
			while(frame != 3):
				await get_tree().create_timer(0).timeout
			play("wake_up2")
			await get_tree().create_timer(0.4).timeout
			$EyeOpen.play()
			await animation_finished
		3:
			while(frame != 1):
				await get_tree().create_timer(0).timeout
			play("wake_up3")
			await get_tree().create_timer(0.4).timeout
			$Quack.play()
			await animation_finished


func nod() -> void:
	play("nod")
	await frame_changed
	$EyeOpen.play()
	await frame_changed
	$EyeOpen.play()
	await animation_finished
	
func hat() -> void:
	play("hat")
	await frame_changed
	$EyeOpen.play()
	await animation_finished
	
func hat_nod() -> void:
	play("hat_nod")
	await frame_changed
	$EyeOpen.play()
	await frame_changed
	$EyeOpen.play()
	await animation_finished
	
func sad() -> void:
	play("sad")
	$EyeOpen.play()
	await animation_finished
	
func normal() -> void:
	play("normal")
	$EyeOpen.play()
	await animation_finished


func _on_frame_changed() -> void:
	if frame == 0 and animation == "sleep":
		await get_tree().create_timer(0.9).timeout
		$Snore.play()
