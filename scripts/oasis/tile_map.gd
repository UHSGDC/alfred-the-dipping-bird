@tool
extends TileMap


@export var generate_random_tiles: bool = false :
	set(value):
		generate_random_tiles = false
		_generate_random_tiles()
@export var extents: Rect2i


func _generate_random_tiles() -> void:
	print("yo")
	for x in range(extents.position.x, extents.position.x + extents.size.x):
		for y in range(extents.position.y, extents.position.y + extents.size.y):
			set_cell(0, Vector2i(x, y), 0, Vector2i(randi_range(0,2),0))
