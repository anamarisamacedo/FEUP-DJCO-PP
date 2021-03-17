extends Node2D

# Nodes references
var tilemap
var tree_tilemap

# Spawner variables
export var spawn_area : Rect2 = Rect2(-1400, -1400, 4000, 4200)
export var start_zombies = 25
var zombie_scene = preload("res://Zombie.tscn")

# Random number generator
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get tilemaps references
	#tilemap = get_tree().root.get_node("root/TileMap")
	#tree_tilemap = get_tree().root.get_node("Root/Tree TileMap")
	
	# Initialize random number generator
	rng.randomize()
	
	# Create zombies
	for i in range(start_zombies):
		instance_zombie()
	
func test_position(position : Vector2):
	# Check if the cell type in this position is grass or sand
	#var cell_coord = tilemap.world_to_map(position)
	#var cell_type_id = tilemap.get_cellv(cell_coord)
	#var grass_or_sand = (cell_type_id == tilemap.tile_set.find_tile_by_name("Grass")) || (cell_type_id == tilemap.tile_set.find_tile_by_name("Sand"))
	
	# Check if there's a tree in this position
	#cell_coord = tree_tilemap.world_to_map(position)
	#cell_type_id = tree_tilemap.get_cellv(cell_coord)
	#var no_trees = (cell_type_id != tilemap.tile_set.find_tile_by_name("Tree"))
	
	# If the two conditions are true, the position is valid
	#return grass_or_sand and no_trees
	return true

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
