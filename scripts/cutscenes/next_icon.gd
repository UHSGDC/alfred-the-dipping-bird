extends Node2D

signal finished


var active: bool = false


func next() -> void:
	$AnimationPlayer.play("RESET")
	active = false
	finished.emit()

func activate() -> void:
	$AnimationPlayer.play("flash")
	active = true
