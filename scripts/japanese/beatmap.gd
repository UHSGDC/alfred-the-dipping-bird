class_name Beatmap extends Resource

@export var stream: AudioStream
@export var bpm: int
@export var beats_till_hit: int = 2
@export var custom_offset: float = 0.0
## String should be a binary number. From left to right bits are: top left, top right, bot left, bot right
@export var beats: PackedStringArray
@export var use_two_drums: bool = false

func get_total_notes() -> int:
	var total_notes: int = 0
	for beat in beats:
		total_notes += beat.count("1")
	return total_notes
