extends Area2D

var hit: bool = false
var speed: float

func _physics_process(delta: float) -> void:
	if !hit:
		position.y += speed * delta
	else:
		$LabelHolder.position.y -= speed * delta


func initialize(start: Vector2, target: Vector2, bpm: int, beats_till_hit: int) -> void:
	global_position.y = start.y
	global_position.x = target.x
	var sec_per_beat := 60.0 / bpm
	var seconds_till_hit = sec_per_beat * beats_till_hit + AudioServer.get_output_latency()
	
	speed = (target.y - start.y) / seconds_till_hit
	

func destroy(score: int) -> void:
	$Sprite2D.hide()
	$DestroyTimer.start()
	hit = true
	if score == 3:
		$LabelHolder/Label.text = "GREAT"
		$LabelHolder/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$LabelHolder/Label.text = "GOOD"
		$LabelHolder/Label.modulate = Color("c3a38a")
	elif score == 1:
		$LabelHolder/Label.text = "OKAY"
		$LabelHolder/Label.modulate = Color("997577")
	elif score == 0:
		$LabelHolder/Label.text = "MISS"
		$LabelHolder/Label.modulate = Color.DARK_GRAY


func _on_destroy_timer_timeout() -> void:
	queue_free()
