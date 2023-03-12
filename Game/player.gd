extends CharacterBody2D

@onready var game = $"/root/Node2D"
@onready var interface = $"/root/Node2D/interface"
var tile_size = 8
@onready var ray = $RayCast2D
@onready var ray2 = $RayCast2D2
var bomb_object = preload("res://Game/bomb.tscn")
var rail_object = preload("res://Game/rail.tscn")

var mine_mode = false
var rail_mode = false
var bomb_mode = false

var bomb_valid = false

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
			
func _ready():
	ray.target_position = Vector2(0, 8)
	ray2.target_position = Vector2(0, 8)
	$bomb.set_visible(false)
	$bomb/preview.play()
	$bomb/radius.play()
	$rail/up.play()
	$rail/down.play()
	$rail/left.play()
	$rail/right.play()
	$riding_up.play()
	$riding_down.play()
	$riding_left.play()
	$riding_up.play()
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
		walls.get_node("overlay").set_visible(false)
		
	if mine_mode and ray2.is_colliding():
		if ray2.get_collider().is_in_group("wall"):
			ray2.get_collider().get_parent().selected()
			
	for rails in $"/root/Node2D/Rails".get_children():
		rails.get_node("overlay").set_visible(false)
			
	if rail_mode:
		var directions = [
			Vector2(0, -8),
			Vector2(0, 8),
			Vector2(-8, 0),
			Vector2(8, 0)
			]
		if !ray.is_colliding() or ray2.get_collider().is_in_group("lava") or ray2.get_collider().is_in_group("rail"):
			for direction in directions:
				if ray.target_position == direction and !ray2.is_colliding():
					$rail.get_child(directions.find(direction)).set_visible(true)
				else:
					$rail.get_child(directions.find(direction)).set_visible(false)
				if ray2.is_colliding():
					if ray2.get_collider().is_in_group("rail"):
						
						ray2.get_collider().get_parent().selected()
		else:
			$rail/up.set_visible(false)
			$rail/down.set_visible(false)
			$rail/left.set_visible(false)
			$rail/right.set_visible(false)
	else:
		$rail/up.set_visible(false)
		$rail/down.set_visible(false)
		$rail/left.set_visible(false)
		$rail/right.set_visible(false)
		
		

func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)
			if ray2.target_position == Vector2(-8, 0):
				$idle_right.set_visible(false)
				$idle_left.set_visible(true)
			elif ray2.target_position == Vector2(8, 0):
				$idle_left.set_visible(false)
				$idle_right.set_visible(true)
	if event.is_action_pressed("mine"):
		if !mine_mode and game.mine_cooldown <= 0:
			mine_mode = true
			bomb_mode = false
			rail_mode = false
		else:
			mine_mode = false
	
	if event.is_action_pressed("bomb"):
		if !bomb_mode and game.bombs >= 1:
			bomb_mode = true
			mine_mode = false
			rail_mode = false
		else:
			bomb_mode = false

	if event.is_action_pressed("rail"):
		if !rail_mode and game.rails >= 1:
			rail_mode = true
			mine_mode = false
			bomb_mode = false
		else:
			rail_mode = false
	
	if event.is_action_pressed("action"):
		mine()
		bomb()
		rail()

func move(direction):
	ray.target_position = inputs[direction] * tile_size
	ray2.target_position = inputs[direction] * tile_size
	ray.force_raycast_update()
	ray2.force_raycast_update()
	if !ray.is_colliding() and !bomb_mode and !rail_mode:
		position += inputs[direction] * tile_size
		game.end_turn()
		
func mine():
	if mine_mode and ray.is_colliding():
		if ray.get_collider().is_in_group("wall"):
			if ray.get_collider().get_parent().block_selected:
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

func rail():
	var rail = rail_object.instantiate()
	var target_pos = self.position + ray.target_position
	var directions = [
		Vector2(0, -8),
		Vector2(0, 8),
		Vector2(-8, 0),
		Vector2(8, 0)
	]
	if rail_mode and !ray.is_colliding() and !ray2.is_colliding():
		if ray.target_position == directions[0] or ray.target_position == directions[1]:
			rail.get_child(0).set_visible(true)
		else:
			rail.get_child(0).set_visible(false)
		if ray.target_position == directions[2] or ray.target_position == directions[3]:
			rail.get_child(1).set_visible(true)
		else:
			rail.get_child(1).set_visible(false)
		rail.set_position(target_pos)
		game.get_node("Rails").add_child(rail)
		rail_mode = false
		game.rails -= 1
	if rail_mode and ray2.is_colliding():
		if ray2.get_collider().is_in_group("rail"):
			if ray2.get_collider().get_parent().rail_selected:
				ray2.get_collider().get_parent().queue_free()
				rail_mode = false
