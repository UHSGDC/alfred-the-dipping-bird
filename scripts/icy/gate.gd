extends Node2D

@export var start_opened: bool = false
@export var show_arrow: bool = true


func _ready() -> void:
	$Arrow.visible = show_arrow
	if start_opened:
		open()
		$Arrow.modulate = Color.WHITE
	else:
		close()
		$Arrow.modulate = Color.TRANSPARENT


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
