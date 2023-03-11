class_name Game
extends Node
@onready var interface = $"/root/Node2D/interface"
@onready var player = $"/root/Node2D/character"

@export var mine_cooldown = 0
@export var bombs = 3
@export var rails = 30

signal pass_time

func end_turn():
	emit_signal("pass_time")
	if mine_cooldown > 0:
		mine_cooldown -= 1

