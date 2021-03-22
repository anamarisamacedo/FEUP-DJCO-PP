extends Node2D

# Nodes references
var tilemap
var tilemap2

# Spawner variables
export var spawn_area : Rect2 = Rect2(-500, -1000, 1000, 2000)
export var start_zombies = 10
var zombie_scene = preload("res://Characters/Zombie.tscn")

# Random number generator
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get tilemaps references
	tilemap = get_tree().root.get_node("/root/MainScene/TileMap")
	tilemap2 = get_tree().root.get_node("/root/MainScene/TileMap2")
	
	# Initialize random number generator
	rng.randomize()
	
	# Create zombies
	for i in range(start_zombies):
		instance_zombie()
	
func test_position(position : Vector2):
	# Check if the cell type in this position is grass or sand
	var cell_coord = tilemap.world_to_map(position)
	var cell_type_id = tilemap.get_cellv(cell_coord)
	var floor_tile = (cell_type_id == tilemap.tile_set.find_tile_by_name("floor"))
	
	cell_coord = tilemap2.world_to_map(position)
	cell_type_id = tilemap2.get_cellv(cell_coord)
	var grass = (cell_type_id == tilemap2.tile_set.find_tile_by_name("tilemap2"))
	
	# If one of the two conditions are true, the position is valid
	return floor_tile or grass

func instance_zombie():
	# Instance the zombie scene and add it to the scene tree
	var zombie = zombie_scene.instance()
	add_child(zombie)
	
	# Place the zombie in a valid position
	var valid_position = false
	while not valid_position:
		zombie.position.x = spawn_area.position.x + rng.randf_range(0, spawn_area.size.x)
		zombie.position.y = spawn_area.position.y + rng.randf_range(0, spawn_area.size.y)
		valid_position = test_position(zombie.position)
