extends Node

@onready var game = $"/root/Node2D"
@onready var player = $"/root/Node2D/character"
var block_selected = false

func _ready():
	$"overlay".play()
	
func selected():
	block_selected = true
	$overlay.set_visible(true)
