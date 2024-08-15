extends Area2D

signal cracked_set(value: bool)

@export var max_freeze_time: float
@export var min_freeze_time: float

var cracked: bool = false :
	set(value):
		cracked = value
		cracked_set.emit(value)
		outline_sprite.visible = !cracked
			

@onready var sprite: Sprite2D = $Sprite2D
@onready var freeze_timer: Timer = $FreezeTimer
@onready var outline_sprite: Sprite2D = $Outline


func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(outline_sprite, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_property(outline_sprite, "modulate", Color.WHITE, 0.5)


func crack() -> void:
	if sprite.frame == 1:
		cracked = true
	if sprite.frame < 2:
		sprite.frame += 1
	start_freezing()
	$CrackSound.play()


func freeze_over() -> void:
	if sprite.frame == 2:
		cracked = false
	if sprite.frame > 0:
		sprite.frame -= 1
	else:
		freeze_timer.stop()


func start_freezing() -> void:
	freeze_timer.start(randf_range(min_freeze_time, max_freeze_time))


func _on_freeze_timer_timeout() -> void:
	freeze_over()
