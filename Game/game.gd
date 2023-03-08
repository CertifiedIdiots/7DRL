class_name Game
extends Node


var mine_mode = false
var block_selected = false
var block_hovered = false

func mine_toggle():
	if $Button.is_pressed():
		mine_mode = true
		print(mine_mode)
	if !$Button.is_pressed():
		mine_mode = false
		print(mine_mode)

func _ready():
	pass

