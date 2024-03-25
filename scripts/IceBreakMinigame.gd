extends BaseMinigame
#Goal: break all of the tiles. 

enum Tile {
	ICE,
	WOOD_PLANK,
	UNBREAKABLE_ICE,
	WALL,
}
@onready var tilemap := $TileMap
var topleft_corner := Vector2(-9, 13)
var bottomright_corner := Vector2(9, -2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func ice_check():
	for x in range(topleft_corner.x, bottomright_corner.x+1):
		for y in range(topleft_corner.y, bottomright_corner.y+1):
			if tilemap.get_cell_atlas_coords(-1, Vector2i(x, y)) == Tile.ICE:
				return false
	return true



func _on_player_check_win_condition(currenttile):
	if ice_check():
		end_minigame(true, 500)
