extends TileMap

@onready var game = $"/root/Node2D"

var wall_object = preload("res://Game/wall_block.tscn")
var lava_object = preload("res://Game/lava.tscn")


var rng = RandomNumberGenerator.new()

var map = []

const PLAYER_SPAWN = Vector2i(10, 17)
const SPAWN_BOX_LENGTH = 1

const WALL_TILE = Vector2i(2, 5)
const FLOOR_TILE = Vector2i(1, 4)

const MAP_START = Vector2i(0, 0)
const MAP_END = Vector2i(20, 20)
const FLOOR_LAYER = 0
const WALL_LAYER = 1
const TILESET_ID = 0


func _ready():
	game.get_node("character").set_position(Vector2i(PLAYER_SPAWN[0]*8, PLAYER_SPAWN[1]*8))
	
	clear_layer(FLOOR_LAYER)
	clear_layer(WALL_LAYER)
	
	for x in range(MAP_END[0]):
		map.append([])
		map[x].resize(MAP_END[1])

	
	for x in range(MAP_START[0], MAP_END[0]+1):
		for y in range(MAP_START[1], MAP_END[1]+1):

			if x == MAP_START[0] or x == MAP_END[0] or y == MAP_START[1] or y == MAP_END[1]:
				set_cell(WALL_LAYER, Vector2i(x, y), TILESET_ID, WALL_TILE)
			else:
				set_cell(FLOOR_LAYER, Vector2i(x, y), TILESET_ID, FLOOR_TILE)
	
	var noise = FastNoiseLite.new()
	noise.seed = rng.randf_range(0,999999)
	for x in range(MAP_START[0]+1, MAP_END[0]):
		for y in range(MAP_START[1]+1, MAP_END[1]):
			var zoom = 10
			var k = noise.get_noise_2d(x*zoom, y*zoom)
			if k < 0:
				var wall = wall_object.instantiate()
				wall.set_position(Vector2i(x*8+4, y*8+4))
				game.get_node("Walls").add_child.call_deferred(wall)
				map[x][y] = wall
			if k > 0.30:
				var lava = lava_object.instantiate()
				lava.set_position(Vector2i(x*8+4, y*8+4))

				game.get_node("Lava").add_child.call_deferred(lava)
				map[x][y] = lava
				
	for x in range(PLAYER_SPAWN[0]-SPAWN_BOX_LENGTH, PLAYER_SPAWN[0]+SPAWN_BOX_LENGTH+1):
		for y in range(PLAYER_SPAWN[1]-SPAWN_BOX_LENGTH, PLAYER_SPAWN[1]+SPAWN_BOX_LENGTH+1):
			if map[x][y]:
				map[x][y].queue_free()
