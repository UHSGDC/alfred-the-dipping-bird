extends AnimatedSprite2D


func wake_up(num: int) -> void:
	match num:
		1:
			while(frame != 4):
				await get_tree().create_timer(0).timeout
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
	await animation_finished
	
func hat() -> void:
	play("hat")
	await animation_finished
	
func hat_nod() -> void:
	play("hat_nod")
	await animation_finished
	
func sad() -> void:
	play("sad")
	await animation_finished
	
func normal() -> void:
	play("normal")
	await animation_finished
