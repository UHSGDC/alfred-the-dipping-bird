extends Node2D

@export var start_opened: bool = false


func _ready() -> void:
	if start_opened:
		open()
	else:
		close()


func open_animation() -> void:
	open()
	$AnimationPlayer.play("open")
func close_animation() -> void:
	close()
	$AnimationPlayer.play("close")
	
	
func open() -> void:
	$Left.rotation = PI / 2
	$Right.rotation = -PI / 2
	$StaticBody2D.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func close() -> void:
	$Left.rotation = 0
	$Right.rotation = 0
	$StaticBody2D.process_mode = Node.PROCESS_MODE_INHERIT
