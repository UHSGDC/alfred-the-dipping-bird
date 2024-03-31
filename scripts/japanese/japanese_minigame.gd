extends BaseMinigame

const NOTE_SCENE: PackedScene = preload("res://scenes/japanese/note.tscn")

@export var targets: Array[Area2D]
@export var beatmap: Beatmap

var player_direction: StringName : 
	set(value):
		player_direction = value
		player.direction = value
var score: int = 0
var beats_till_hit: int = 0

@onready var conductor: RhythmConductor = $Conductor
@onready var player: Sprite2D = $Player

func _ready() -> void:
	start()
	player_direction = "up"
	for target in targets:
		target.note_hit.connect(_on_note_hit)

func start() -> void:
	conductor.bpm = beatmap.bpm
	conductor.stream = beatmap.stream
	beats_till_hit = beatmap.beats_till_hit
	conductor.play_with_beat_offset(4)


func _unhandled_input(event: InputEvent) -> void:
	# Changing player direction
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
		print("score: " + str(score))


func _on_rhythm_conductor_beat_reached(beat_position: int) -> void:
	# If the beat_position is within the beats array and the beat at that position has all 4 beats
	if beat_position < beatmap.beats.size() and beatmap.beats[beat_position].length() == 4:
		_read_and_spawn_notes(beatmap.beats[beat_position])
	print("current_beat: " + str(beat_position))

func _read_and_spawn_notes(notes: String) -> void:
	if notes[0] == "1":
		_spawn_note($TopStart.global_position, targets[0].global_position)
	if notes[1] == "1":
		_spawn_note($TopStart.global_position, targets[1].global_position)
	if notes[2] == "1":
		_spawn_note($BottomStart.global_position, targets[2].global_position)
	if notes[3] == "1":
		_spawn_note($BottomStart.global_position, targets[3].global_position)


func _spawn_note(note_start: Vector2, note_target: Vector2) -> void:
	var note := NOTE_SCENE.instantiate()
	add_child(note)
	note.initialize(note_start, note_target, beatmap.bpm, 2)
