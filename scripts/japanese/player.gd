extends Sprite2D


var direction: StringName :
	set(value):
		direction = value
		if value == "up":
			flip_v = true
			lt_stick.show()
			rt_stick.show()
			lb_stick.hide()
			rb_stick.hide()
		else:
			flip_v = false
			lt_stick.hide()
			rt_stick.hide()
			lb_stick.show()
			rb_stick.show()
			
@onready var lt_stick: Node2D = $LeftTopStick
@onready var rt_stick: Node2D = $RightTopStick
@onready var lb_stick: Node2D = $LeftBotStick
@onready var rb_stick: Node2D = $RightBotStick

func hit(left: bool) -> void:
	if left:
		if direction == "up":
			lt_stick.hit()
		else:
			lb_stick.hit()
	else:
		if direction == "up":
			rt_stick.hit()
		else:
			rb_stick.hit()
