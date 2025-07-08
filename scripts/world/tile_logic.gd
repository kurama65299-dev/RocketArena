extends Node

@onready var tile_map: TileMapLayer = null
var tile_data : Dictionary = {}
var normal_health: int = 80 + (40 * GlobalSettings.players.size())
var high_health: int = 600 + (200 * GlobalSettings.players.size())
var low_health: int = 40
var maps: Dictionary = GlobalSettings.maps

func _ready():
	load_map()
	var map_size = tile_map.get_used_rect()
	for x in range(map_size.position.x, map_size.end.x):
		for y in range(map_size.position.y, map_size.end.y):
			var coords = Vector2i(x,y)
			var id = tile_map.get_cell_source_id(coords)
			if id != -1:
				if tile_map.get_cell_atlas_coords(coords) == Vector2i(0,0):
					tile_data[coords] = normal_health
				elif tile_map.get_cell_atlas_coords(coords) == Vector2i(1,0):
					tile_data[coords] = low_health
				elif tile_map.get_cell_atlas_coords(coords) == Vector2i(2,0):
					tile_data[coords] = high_health
					
func damage_tile(coords, damage):
	if tile_data.has(coords):
		if tile_data[coords] - damage <= 0:
			tile_map.set_cell(coords, -1)
			tile_data.erase(coords)
		else:
			tile_data[coords] -= damage
			
		if tile_map.get_cell_atlas_coords(coords) == Vector2i(0,0):
			if tile_data[coords] < normal_health / 1.5:
				tile_map.set_cell(coords, 0, Vector2i(1,0))
		if tile_map.get_cell_atlas_coords(coords) == Vector2i(2,0):
			if tile_data[coords] < high_health / 1.5:
				tile_map.set_cell(coords, 0, Vector2i(3,0))

func load_map():
	var map
	if GlobalSettings.map == maps.SPIKY_BATTLE:
		map = preload("res://scenes/maps/SpikyBattle.tscn")
	elif GlobalSettings.map == maps.DESCENDING_WAR:
		map = preload("res://scenes/maps/DescendingWar.tscn")
	elif GlobalSettings.map == maps.ISLAMIC_HELL:
		map = preload("res://scenes/maps/IslamicHell.tscn")
	elif GlobalSettings.map == maps.IRON_VALLEY:
		map = preload("res://scenes/maps/IronValley.tscn")
	elif GlobalSettings.map == maps.JUMPY_CONFRONTATION:
		map = preload("res://scenes/maps/JumpyConfrontation.tscn")
	elif GlobalSettings.map == maps.SEDIMENT_ERUPTION:
		map = preload("res://scenes/maps/SedimentEruption.tscn")
	var new_map = map.instantiate()
	add_child(new_map)
	tile_map = new_map
