extends Node

@onready var tile_map: TileMapLayer = $TileMapLayer
var tile_data : Dictionary = {}

func _ready():
	var map_size = tile_map.get_used_rect()
	for x in range(map_size.position.x, map_size.end.x):
		for y in range(map_size.position.y, map_size.end.y):
			var coords = Vector2i(x,y)
			var id = tile_map.get_cell_source_id(coords)
			if id != -1:
				tile_data[coords] = 100
func damage_tile(damage, coords):
	if tile_data.has(coords):
		if tile_data[coords] - damage <= 0:
			tile_map.set_cell(coords, -1)
			tile_data.erase(coords)
		else:
			tile_data[coords] -= damage
