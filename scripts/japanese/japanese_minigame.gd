extends BaseMinigame

const NOTE_SCENE: PackedScene = preload("res://scenes/japanese/note.tscn")
const BEATMAPS: Array[Beatmap] = [preload("res://assets/japanese/phsummit.tres"), preload("res://assets/japanese/adbniagara.tres")]

@export var targets: Array[Area2D]
@export var beatmap: Beatmap
@export var print_score: bool = false

var scores: Array[int] = [0, 0]
var beats_till_hit: int = 0
var cur_beatmap_idx: int = 0

var total_notes: Array[int] = [0, 0]
var sec_per_half_beat: float
var sec_per_quarter_beat: float

@onready var conductor: RhythmConductor = $Conductor
@onready var player: Sprite2D = $Player
@onready var half_beat_timer: Timer = $HalfBeatTimer
@onready var quarter_beat_timer: Timer = $QuarterBeatTimer

func _ready() -> void:
	if !debug_mode:
		beatmap = BEATMAPS[0]
	start()
	
	for target in targets:
		target.note_hit.connect(_on_note_hit)

func start() -> void:
	scores[cur_beatmap_idx] = 0
	conductor.reset()
	conductor.bpm = beatmap.bpm
	conductor.sec_per_beat = 60.0 / beatmap.bpm
	conductor.stream = beatmap.stream
	conductor.custom_offset = beatmap.custom_offset
	# 30.0 / bpm is the length of half a beat in seconds
	sec_per_half_beat = 30.0 / beatmap.bpm
	sec_per_quarter_beat = 15.0 / beatmap.bpm
	beats_till_hit = beatmap.beats_till_hit
	total_notes[cur_beatmap_idx] = beatmap.get_total_notes()
	conductor.play_with_beat_offset(beats_till_hit)
	update_score_ui()


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		$AnimationPlayer.play("finish")
		end_minigame(1200, "CHETINFG!")


func _unhandled_input(event: InputEvent) -> void:
	# Player animation
	if event.is_action_pressed("left"):
		player.hit(true)
	if event.is_action_pressed("right"):
		player.hit(false)
	
	# Target handling input
	for target in targets:
		target.handle_input()


func _on_note_hit(score_to_add: int) -> void:
	scores[cur_beatmap_idx] += score_to_add
	update_score_ui()
	if print_score:
		print("score: " + str(scores[cur_beatmap_idx]) + "/" + str(total_notes[cur_beatmap_idx] * 3)) # 3 is the score of perfect
		
func update_score_ui() -> void:
	$UI/Score.text = "Score: %3d/ %3d" % [scores[cur_beatmap_idx], total_notes[cur_beatmap_idx] * 3]


func _on_rhythm_conductor_beat_reached(beat_position: int) -> void:
	# If the beat_position is within the beats array and the beat at that position has both beats
	if beat_position < beatmap.beats.size() and beatmap.beats[beat_position].length() >= 2:
		_read_and_spawn_notes(beatmap.beats[beat_position])
	if debug_mode:
		print("beat: " + str(beat_position))


func _read_and_spawn_notes(notes: String) -> void:
	if notes[0] == "1":
		_spawn_note($TopStart.global_position, targets[0].global_position)
	if notes[1] == "1":
		_spawn_note($TopStart.global_position, targets[1].global_position)
	if notes.length() == 4:
		half_beat_timer.start(sec_per_half_beat)
		await half_beat_timer.timeout
		if notes[2] == "1":
			_spawn_note($TopStart.global_position, targets[0].global_position)
		if notes[3] == "1":
			_spawn_note($TopStart.global_position, targets[1].global_position)
	elif notes.length() == 8:
		# 1/4
		quarter_beat_timer.start(sec_per_quarter_beat)
		await quarter_beat_timer.timeout
		if notes[2] == "1":
			_spawn_note($TopStart.global_position, targets[0].global_position)
		if notes[3] == "1":
			_spawn_note($TopStart.global_position, targets[1].global_position)
		
		# 2/4
		quarter_beat_timer.start(sec_per_quarter_beat)
		await quarter_beat_timer.timeout
		if notes[4] == "1":
			_spawn_note($TopStart.global_position, targets[0].global_position)
		if notes[5] == "1":
			_spawn_note($TopStart.global_position, targets[1].global_position)
			
		# 3/4
		quarter_beat_timer.start(sec_per_quarter_beat)
		await quarter_beat_timer.timeout
		if notes[6] == "1":
			_spawn_note($TopStart.global_position, targets[0].global_position)
		if notes[7] == "1":
			_spawn_note($TopStart.global_position, targets[1].global_position)


func _spawn_note(note_start: Vector2, note_target: Vector2) -> void:
	var note := NOTE_SCENE.instantiate()
	add_child(note)
	note.initialize(note_start, note_target, beatmap.bpm, beats_till_hit)


func _on_conductor_finished() -> void:
	# Show score / total score and show retry/next button
	$UI/Menu.show()
	
func finish() -> void:
	$AnimationPlayer.play("finish")
	end_minigame(scores[0] + scores[1], "Level 1 score: %s/%s\nLevel 2 score: %s/%s" % [scores[0], total_notes[0] * 3, scores[1], total_notes[1] * 3])


func _on_next_pressed() -> void:
	$UI/Menu.hide()
	if cur_beatmap_idx == 1:
		finish()
	else:
		cur_beatmap_idx += 1
		beatmap = BEATMAPS[cur_beatmap_idx]
		start()


func _on_retry_pressed() -> void:
	$UI/Menu.hide()
	start()
