extends BaseMinigame

var time_elapsed: float :
	set(value):
		time_elapsed = value
		$CanvasLayer/Time.text = "Time: %6.2f" % value
var track_time: bool = false


func _ready() -> void:
	time_elapsed = 0


func _process(delta: float) -> void:
	if track_time:
		time_elapsed += delta


func _on_room_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		track_time = true
		time_elapsed = 0


func _on_room_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		track_time = false


func _on_finish_area_entered(area: Area2D) -> void:
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer/BlackScreen.fade_in()


func _on_black_screen_fade_done() -> void:
	end_minigame(roundf(time_elapsed), "It took you %.0f seconds to complete the level. Lower is better!" % time_elapsed)
