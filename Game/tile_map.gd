extends TileMap

@onready var game = $"/root/Node2D"

var wall_object = preload("res://Game/wall_block.tscn")
var lava_object = preload("res://Game/lava.tscn")


var rng = RandomNumberGenerator.new()


const WALL_TILE = Vector2i(2, 5)

const MAP_START = Vector2i(4, 4)
const MAP_END = Vector2i(21, 13)
const WALL_LAYER = 1
const TILESET_ID = 0

func _ready():
	clear_layer(WALL_LAYER)
	var noise = FastNoiseLite.new()
	noise.seed = rng.randf_range(0,999999)
	for x in range(MAP_START[0], MAP_END[0]+1):
		for y in range(MAP_START[1], MAP_END[1]+1):
			var k = noise.get_noise_2d(x, y)
			if k < 0:
				var wall = wall_object.instantiate()
				wall.set_position(Vector2i(x*8-4, y*8-4))
				game.add_child.call_deferred(wall)
			if k > 0:
				var lava = lava_object.instantiate()
				lava.set_position(Vector2i(x*8-4, y*8-4))
				game.add_child.call_deferred(lava)
				#set_cell(WALL_LAYER, Vector2i(x, y), TILESET_ID, WALL_TILE)
