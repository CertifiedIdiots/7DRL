extends Node

@onready var lava_variants = $types.get_children()
var rng = RandomNumberGenerator.new()
var selected_variant = null
var frame_speed = null
var random_frame = null
var nearby_blocks = []

func _ready():
	$PointLight2D.set_visible(false)
	for type in lava_variants:
		type.play()
		type.set_visible(false)
	
	rng.randomize()
	selected_variant = rng.randi_range(0, 3)
	$types.get_child(selected_variant).set_visible(true)
	
	rng.randomize()
	random_frame = rng.randi_range(0, 3)
	$types.get_child(selected_variant).set_frame(random_frame)
	
func _process(delta):
	nearby_blocks = $Area2D.get_overlapping_areas()
	for block in nearby_blocks:
		if !block.is_in_group("lava"):
			nearby_blocks.erase(block)
	if nearby_blocks.size() <= 3:
		$PointLight2D.set_visible(true)
	else:
		$PointLight2D.set_visible(false)
	
func burn():
	pass

