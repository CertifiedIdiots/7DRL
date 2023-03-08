extends Node

@onready var game = $"/root/Node2D"

func _ready():
	$"mine overlay".play()
	
func hovered():
	if game.mine_mode:
		$"mine overlay".set_visible(true)
		game.block_hovered = true
	
func unhovered():
	$"mine overlay".set_visible(false)
	game.block_hovered = false
	
func mine(viewport, event, shape_idx):
	if game.mine_mode and game.block_hovered:
		if event.is_action_pressed("left_click"):
			self.queue_free()
