extends Node

var tile_size = 8
var center = self.position
@onready var wall_blocks = $"/root/Node2D/Walls".get_children()
@onready var game = $"/root/Node2D"
@onready var player = $"/root/Node2D/character"

var state = 1
@export var radius = 2

var affected_blocks = []
var affected_player = null

func _ready():
	self.state = 1
	$bomb1.set_visible(true)
	$bomb1.play()
	$bomb2.play()
	$bomb3.play()

func change_state():
	affected_blocks = self.get_node("radius").get_overlapping_areas()
	affected_player = self.get_node("radius").get_overlapping_bodies()
	self.state += 1
	if self.state == 2:
		$bomb1.set_visible(false)
		$bomb2.set_visible(true)
	if self.state == 3:
		$bomb2.set_visible(false)
		$bomb3.set_visible(true)
	if self.state == 4:
		explode()
		
func explode():
	self.queue_free()
	for block in affected_blocks:
		block.get_parent().queue_free()
	for player in affected_player:
		player.queue_free()
		get_tree().change_scene_to_file("res://Game/main_menu.tscn")
		print("YOU DIED")
