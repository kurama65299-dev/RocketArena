extends Node

@onready var tile_map: TileMapLayer = null
var tile_data : Dictionary = {}
var normal_health: int = 140

func _ready():
	load_map()
	var map_size = tile_map.get_used_rect()
	for x in range(map_size.position.x, map_size.end.x):
		for y in range(map_size.position.y, map_size.end.y):
			var coords = Vector2i(x,y)
			var id = tile_map.get_cell_source_id(coords)
			if id != -1:
				tile_data[coords] = normal_health
func damage_tile(coords, damage):
	if tile_data.has(coords):
		if tile_data[coords] - damage <= 0:
			tile_map.set_cell(coords, -1)
			tile_data.erase(coords)
		elif tile_data[coords] - damage <= normal_health / 1.5:
			tile_map.set_cell(coords, 0, Vector2i(1,0),0)
			tile_data[coords] -= damage
		else:
			tile_data[coords] -= damage

func load_map():
	var map
	if GlobalSettings.map == "SpikyBattle":
		map = load("res://scenes/maps/SpikyBattle.tscn")
	elif GlobalSettings.map == "DescendingWar":
		map = load("res://scenes/maps/DescendingWar.tscn")
	var new_map = map.instantiate()
	add_child(new_map)
	tile_map = new_map
