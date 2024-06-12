extends BaseMinigame

var time_elapsed: float
var track_time: bool = false


func _process(delta: float) -> void:
	if track_time:
		time_elapsed += delta


func _on_room_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		track_time = true


func _on_room_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		track_time = false
