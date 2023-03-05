extends CharacterBody2D
@export var speed = 400
var tile_size = 8
@onready var ray = $RayCast2D

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)

func move(direction):
	ray.target_position = inputs[direction] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += inputs[direction] * tile_size
	
