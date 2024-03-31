class_name Beatmap extends Resource

@export var stream: AudioStream
@export var bpm: int
## String should be a binary number. From left to right bits are: top left, top right, bot left, bot right
@export var beats: PackedStringArray
