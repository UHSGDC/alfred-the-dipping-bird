class_name IceCrack extends AnimatedSprite2D

var lower_x_limit: int
var upper_x_limit: int
const imagewidthhalved = 220 / 2

var player_in_area: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	
	lower_x_limit = position.x-imagewidthhalved
	upper_x_limit = position.x+imagewidthhalved
	prints(lower_x_limit, upper_x_limit)
	
	sprite_frames = preload("res://IceCrack.tres")
	self.frame = 0
	
	
	

	var player = get_node("../Player")
	
	player.landed.connect(when_player_lands)
	
	

func when_player_lands(player_position: Vector2) -> int: #returns new frame index
	print(player_position)
	if lower_x_limit < player_position.x and player_position.x < upper_x_limit:
		if self.frame == 3:
			queue_free()
		else:
			self.frame += 1
	
	return self.frame


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
