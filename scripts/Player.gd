extends Sprite2D


enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NONE,
}

enum Tile {
	ICE,
	WOOD_PLANK,
	UNBREAKABLE_ICE,
	WALL,
	CRACKED_ICE
}

const DISTANCE_PER_TILE := 256
const DISTANCE_PER_FRAME := 16
const FRAMES_PER_CHECK := DISTANCE_PER_TILE/DISTANCE_PER_FRAME

var DIRECTION_STRINGS: Array = Direction.keys()

var player_direction: Direction = Direction.NONE

var unallowed_direction: Vector2 = Vector2.ZERO

var sliding := false

var vertical_input: int
var horizontal_input: int
var input: Vector2
var frames_since_input: int

signal check_win_condition(currenttile: Tile)

const starting_coords = Vector2(2176, -384)

@onready var tilemap := $"../TileMap"
#@onready var camera := $"../Camera2D"



# Called when the node enters the scene tree for the first time.

func get_tile(coords: Vector2i) -> Tile:
	print("coords: ", tilemap.local_to_map(coords))
	var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(-1, tilemap.local_to_map(Vector2i(coords)))
	print("atlas_coords: ", atlas_coords)
	match atlas_coords:
		Vector2i.ZERO:
			return Tile.ICE
		Vector2i(16, 0):
			return Tile.WOOD_PLANK
		Vector2i(0, 16):
			return Tile.UNBREAKABLE_ICE
		Vector2i(16, 16):
			return Tile.WALL
	return Tile.CRACKED_ICE

func _ready():
	self.position = starting_coords
	

func _input(_event) -> void:
	if not sliding:
		#print("getting input")
		vertical_input = Input.get_axis("up", "down")
		horizontal_input = Input.get_axis("left", "right")
		input = Vector2(horizontal_input, vertical_input)
		
		#prints("input:", input)
		if (input.x or input.y) and input.x != input.y and input != unallowed_direction: #either one (not both) is 1
			sliding = true
			frames_since_input = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sliding:
		var this_tile := get_tile(self.position)
		var next_tile := get_tile(self.position + input*128)
		
		
		
		frames_since_input += 1
		if next_tile != Tile.WALL:
			#if next_tile != Tile.CRACKED_ICE:
				self.position += DISTANCE_PER_FRAME*input
			
		
		if frames_since_input % FRAMES_PER_CHECK == 0:
			#prints(this_tile, next_tile)
			if this_tile == Tile.ICE:
				tilemap.set_cell(0, tilemap.local_to_map(self.position), 0, Vector2i(-256, -256)) #set to none; can be changed to a cracked tile later
				tilemap.set_cell(0, tilemap.local_to_map(starting_coords), 0, Vector2i(-256, -256))
			if this_tile == Tile.WOOD_PLANK:
				unallowed_direction = input
				sliding = false
			elif next_tile in [Tile.WALL, Tile.CRACKED_ICE]:
				sliding = false
			
			#else:
		tilemap.force_update()

		

