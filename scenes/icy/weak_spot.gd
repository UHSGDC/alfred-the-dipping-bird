extends Area2D

signal cracked_set(value: bool)

var cracked: bool = false :
	set(value):
		cracked = value
		cracked_set.emit(value)

@onready var sprite: Sprite2D = $Sprite2D

func crack() -> void:
	if sprite.frame == 1:
		cracked = true
	if sprite.frame < 2:
		sprite.frame += 1


func freeze_over() -> void:
	if sprite.frame == 2:
		cracked = false
	if sprite.frame > 0:
		sprite.frame -= 1
