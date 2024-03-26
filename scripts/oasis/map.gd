extends TextureRect

@export var dunes: Node2D
@export var oasis: Node2D

@export var dune_textures: Array[Texture2D]
@export var oasis_texture: Texture2D

@export var level_visible_area: Vector2 = Vector2(2400, 2400)
@export var map_useable_area: Vector2 = Vector2(100, 100)

@onready var level_to_map_ratio: Vector2 = level_visible_area / map_useable_area


func _ready() -> void:
	for dune in dunes.get_children():
		_place_sprite(dune_textures[dune.dune_size], dune.position)
	_place_sprite(oasis_texture, oasis.position)


func _place_sprite(tex: Texture2D, pos: Vector2) -> void:
		var sprite := Sprite2D.new()
		add_child(sprite)
		sprite.position = level_to_map_coords(pos)
		sprite.scale = Vector2.ONE / level_to_map_ratio
		sprite.texture = tex


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		show()
	elif event.is_action_released("action"):
		hide()


# Scales coords in the level to coords on the map and then offsets so that the origin is the top left
func level_to_map_coords(coords: Vector2) -> Vector2:
	return coords / level_to_map_ratio +  texture.get_size() / 2
