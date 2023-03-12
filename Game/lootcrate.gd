extends Node

@onready var game = $"/root/Node2D"
@onready var player = $"/root/Node2D/character"

func _ready():
	$crate.play()

func pickup(body):
	if body == player:
		game.bombs += randi_range(1, 5)
		game.rails += randi_range(5, 15)
		self.queue_free()
