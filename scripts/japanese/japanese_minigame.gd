extends BaseMinigame

const NOTE_SCENE: PackedScene = preload("res://scenes/japanese/note.tscn")

@export var targets: Array[Area2D]

var player_direction: StringName = "up"
var score: int = 0
var beats_till_hit: int = 0

@onready var conductor: RhythmConductor = $Conductor

func _ready() -> void:
	start()
	for target in targets:
		target.note_hit.connect(_on_note_hit)

# TODO: Create a match statement for the three songs to feed in the correct data
func initialize(_song: StringName) -> void:
	pass

func start() -> void:
	conductor.play_from_beat(1)


func _on_note_hit(score_to_add: int) -> void:
	score += score_to_add


func _on_rhythm_conductor_beat_reached(beat_position: int) -> void:
	if beat_position % 2 == 0:
		_spawn_note($TopStart.global_position, targets[0].global_position)



func _spawn_note(note_start: Vector2, note_target: Vector2) -> void:
	var note := NOTE_SCENE.instantiate()
	add_child(note)
	note.initialize(note_start, note_target, conductor.bpm, 2)
