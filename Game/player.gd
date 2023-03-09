extends CharacterBody2D

@onready var game = $"/root/Node2D"
@onready var interface = $"/root/Node2D/interface"
var tile_size = 8
@onready var ray = $RayCast2D
var bomb_object = preload("res://Game/bomb.tscn")

var mine_mode = false
var bridge_mode = false
var bomb_mode = false

var bomb_valid = false

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
			
func _ready():
	ray.target_position = Vector2(0, 8)
	$bomb.set_visible(false)
	$bomb/preview.play()
	$bomb/radius.play()
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
			
func _process(delta):
	interface.update()
	if bomb_mode and !ray.is_colliding():
		$bomb.set_visible(true)
		bomb_valid = true
	else:
		$bomb.set_visible(false)
		bomb_valid = false
	$bomb.position = ray.target_position
	for walls in $"/root/Node2D/Walls".get_children():
		walls.get_child(1).set_visible(false)
		
	if mine_mode and ray.is_colliding():
		if not ray.get_collider() is TileMap:
			ray.get_collider().get_parent().selected()
		

func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)
	if event.is_action_pressed("mine"):
		if !mine_mode and game.mine_cooldown <= 0:
			mine_mode = true
			bomb_mode = false
			bridge_mode = false
		else:
			mine_mode = false
	
	if event.is_action_pressed("bomb"):
		if !bomb_mode and game.bombs >= 1:
			bomb_mode = true
			mine_mode = false
			bridge_mode = false
		else:
			bomb_mode = false

	if event.is_action_pressed("bridge"):
		if !bridge_mode:
			bridge_mode = true
			mine_mode = false
			bomb_mode = false
		else:
			bridge_mode = false
	
	if event.is_action_pressed("action"):
		mine()
		bomb()
#		bridge()

func move(direction):
	ray.target_position = inputs[direction] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding() and !bomb_mode:
		position += inputs[direction] * tile_size
		game.end_turn()
		
func mine():
	if mine_mode and ray.get_collider().get_parent().block_selected:
		ray.get_collider().get_parent().queue_free()
		mine_mode = false
		game.mine_cooldown += 3

func bomb():
	if bomb_mode and bomb_valid:
		var bomb = bomb_object.instantiate()
		var target_pos = self.position + ray.target_position
		bomb.set_position(target_pos)
		game.add_child(bomb)
		game.connect("pass_time", Callable(bomb, "change_state"))
		bomb_mode = false
		game.bombs -= 1
