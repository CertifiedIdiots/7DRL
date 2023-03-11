extends Node

@onready var is_up = $up.is_visible()
@onready var is_side = $side.is_visible()

@onready var variants = [$up, $side, $down_right, $down_left, $up_right, $up_left]

var nearby_rails = []

func ready():
	pass

func _process(delta):
	if $ray_up.is_colliding():
		if $ray_left.is_colliding():
			for pos in variants:
				pos.set_visible(false)
			$down_left.set_visible(true)
			
		elif $ray_right.is_colliding():
			for pos in variants:
				pos.set_visible(false)
			$down_right.set_visible(true)
			
	elif $ray_down.is_colliding():
		if $ray_left.is_colliding():
			for pos in variants:
				pos.set_visible(false)
			$up_left.set_visible(true)
			
		elif $ray_right.is_colliding():
			for pos in variants:
				pos.set_visible(false)
			$up_right.set_visible(true)

#	if $ray_left.is_colliding():
#		if $ray_up.is_colliding():
#			for pos in variants:
#				pos.set_visible(false)
#			$up_left.set_visible(true)
#
#		if $ray_down.is_colliding():
#			for pos in variants:
#				pos.set_visible(false)
#			$down_right.set_visible(true)
	
	
	
	
	
	
	
	
#	if $ray_up.is_colliding():
#		if nearby_rails.size() == 0:
#			nearby_rails.append($ray_up.get_collider().get_parent())
#			nearby_rails.append($ray_up.get_collider().get_parent())
#
#		for rail in nearby_rails:
#			if rail.get_node("up").is_visible():
#
#				if is_up and $ray_right.is_colliding():
#					$up.set_visible(false)
#					$down_right.set_visible(true)
#				elif is_up and $ray_left.is_colliding():
#					$up.set_visible(false)
#					$down_left.set_visible(true)
#				elif is_side and $ray_up.is_colliding():
#					$side.set_visible(false)
#					$down_left.set_visible(true)
#
#
#	elif $ray_down.is_colliding():
#		if nearby_rails.size() == 0:
#			nearby_rails.append($ray_down.get_collider().get_parent())
#			nearby_rails.append($ray_down.get_collider().get_parent())
#
#		for rail in nearby_rails:
#			if rail.get_node("up").is_visible():
#				if is_up and $ray_right.is_colliding():
#					$up.set_visible(false)
#					$up_right.set_visible(true)
#				elif is_up and $ray_left.is_colliding():
#					$up.set_visible(false)
#					$up_left.set_visible(true)
#				elif is_side and $ray_down.is_colliding():
#					$side.set_visible(false)
#					if $ray_left.is_colliding():
#						$up_left.set_visible(true)
#					else: $up_right.set_visible(true)

