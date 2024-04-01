extends BaseMinigame

const NOTE_SCENE: PackedScene = preload("res://scenes/japanese/note.tscn")

@export var targets: Array[Area2D]
@export var beatmap: Beatmap

var score: int = 0
var beats_till_hit: int = 0

var player_direction: StringName : 
	set(value):
		player_direction = value
		player.direction = value
var total_notes: int
var sec_per_half_beat: float

@onready var conductor: RhythmConductor = $Conductor
@onready var player: Sprite2D = $Player
@onready var half_beat_timer: Timer = $HalfBeatTimer

func _ready() -> void:
	player_direction = "up"
	start()
	
	for target in targets:
		target.note_hit.connect(_on_note_hit)

func start() -> void:
	conductor.bpm = beatmap.bpm
	conductor.sec_per_beat = 60.0 / beatmap.bpm
	conductor.stream = beatmap.stream
	# 30.0 / bpm is the length of half a beat in seconds
	sec_per_half_beat = 30.0 / beatmap.bpm
	beats_till_hit = beatmap.beats_till_hit
	total_notes = beatmap.get_total_notes()
	conductor.play_from_beat(45, beats_till_hit)


func _unhandled_input(event: InputEvent) -> void:
	# Changing player direction
	if beatmap.use_two_drums:
		if event.is_action_pressed("up"):
			player_direction = "up"
		elif event.is_action_pressed("down"):
			player_direction = "down"
	
	# Player animation
	if event.is_action_pressed("left"):
		player.hit(true)
	if event.is_action_pressed("right"):
		player.hit(false)
	
	# Target handling input
	for target in targets:
		target.handle_input(player_direction)


func _on_note_hit(score_to_add: int) -> void:
	score += score_to_add
	if debug_mode:
		print("score: " + str(score) + "/" + str(total_notes * 3))


func _on_rhythm_conductor_beat_reached(beat_position: int) -> void:
	# If the beat_position is within the beats array and the beat at that position has all 4 beats
	if beat_position < beatmap.beats.size() and beatmap.beats[beat_position].length() >= 4:
		_read_and_spawn_notes(beatmap.beats[beat_position])
	if debug_mode:
		print("beat: " + str(beat_position))


func _read_and_spawn_notes(notes: String) -> void:
	if notes[0] == "1":
		_spawn_note($TopStart.global_position, targets[0].global_position)
	if notes[1] == "1":
		_spawn_note($TopStart.global_position, targets[1].global_position)
	if notes[2] == "1":
		_spawn_note($BottomStart.global_position, targets[2].global_position)
	if notes[3] == "1":
		_spawn_note($BottomStart.global_position, targets[3].global_position)
	if notes.length() == 8:
		half_beat_timer.start(sec_per_half_beat)
		await half_beat_timer.timeout
		if notes[4] == "1":
			_spawn_note($TopStart.global_position, targets[0].global_position)
		if notes[5] == "1":
			_spawn_note($TopStart.global_position, targets[1].global_position)
		if notes[6] == "1":
			_spawn_note($BottomStart.global_position, targets[2].global_position)
		if notes[7] == "1":
			_spawn_note($BottomStart.global_position, targets[3].global_position)


func _spawn_note(note_start: Vector2, note_target: Vector2) -> void:
	var note := NOTE_SCENE.instantiate()
	add_child(note)
	note.initialize(note_start, note_target, beatmap.bpm, beats_till_hit)
