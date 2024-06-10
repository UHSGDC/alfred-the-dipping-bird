extends BaseMinigame

var ice_broken: bool = false

func _on_weak_spots1_uncracked_count_changed(new_value: int) -> void:
	if new_value == 0:
		ice_broken = true
		$Room1/Water.show()
		$Room1/WeakSpots.hide()
		$Room1/WeakSpots.process_mode = Node.PROCESS_MODE_DISABLED
		$Room1/CrackGate.process_mode = Node.PROCESS_MODE_DISABLED


func _on_weak_spots2_uncracked_count_changed(new_value: int) -> void:
	if new_value == 0:
		ice_broken = true
		$Room2/Water.show()
		$Room2/WeakSpots.hide()
		$Room2/WeakSpots.process_mode = Node.PROCESS_MODE_DISABLED
		$Room2/CrackGate.process_mode = Node.PROCESS_MODE_DISABLED


func _on_weak_spots3_uncracked_count_changed(new_value: int) -> void:
	if new_value == 0:
		ice_broken = true
		$Room3/Water.show()
		$Room3/WeakSpots.hide()
		$Room3/WeakSpots.process_mode = Node.PROCESS_MODE_DISABLED
		$Room3/CrackGate.process_mode = Node.PROCESS_MODE_DISABLED
