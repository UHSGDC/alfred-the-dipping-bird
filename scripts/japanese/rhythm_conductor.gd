class_name RhythmConductor extends AudioStreamPlayer

signal beat_reached(beat_position: int)

var bpm: int

# Tracking the beat and song position
var song_position_seconds: float = 0.0
var song_position_beats: int = 1
var last_reported_beat: int = 0
var beats_before_start: int = 0
var sec_per_beat: float

var audio_latency: float

var custom_offset: float = 0.0


func reset() -> void:
	song_position_seconds = 0
	song_position_beats = 1
	last_reported_beat = 0
	beats_before_start = 0
	audio_latency = 0


func _physics_process(_delta: float) -> void:
	if playing:
		song_position_seconds = get_playback_position() + AudioServer.get_time_since_last_mix() - custom_offset
		song_position_seconds -= audio_latency
		song_position_beats = int(ceilf(song_position_seconds / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat() -> void:
	if last_reported_beat < song_position_beats:
		audio_latency = AudioServer.get_output_latency()
		beat_reached.emit(song_position_beats)
		last_reported_beat = song_position_beats


func play_with_beat_offset(beat: int) -> void:
	beats_before_start = beat
	if (beat == 0):
		play()
	else:
		$StartTimer.wait_time = sec_per_beat
		$StartTimer.start()
	_report_beat()


#func closest_beat(nth) -> void:
	#var closest = int(round((song_position_seconds / sec_per_beat) / nth) * nth) 
	#var time_off_beat = abs(closest * sec_per_beat - song_position_seconds)
	#return Vector2(closest, time_off_beat)


func play_from_beat(beat: int, beat_offset: int) -> void:
	play()
	seek((beat - 1) * sec_per_beat)
	beats_before_start = beat_offset


func _on_start_timer_timeout() -> void:
	song_position_beats += 1
	if song_position_beats < beats_before_start:
		$StartTimer.start()
	elif song_position_beats == beats_before_start:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency() + custom_offset)
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
	

