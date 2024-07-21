extends Sprite2D
			
@onready var lt_stick: Node2D = $LeftTopStick
@onready var rt_stick: Node2D = $RightTopStick

func hit(left: bool) -> void:
	if left:
		lt_stick.hit()
	else:
		rt_stick.hit()
