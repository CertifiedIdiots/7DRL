extends Node
@onready var game = $"/root/Node2D"
@onready var player = $"/root/Node2D/character"

func _ready():
	$actions/mine.set_text("Mine")
	$actions/mine.add_theme_color_override("font_color", Color("LIGHT_BLUE"))
	$actions/bomb.set_text(str("Bomb   [ ", game.bombs, " ]"))
	$actions/bomb.add_theme_color_override("font_color", Color("LIGHT_BLUE"))
	$actions/bridge.set_text("Bridge")
	$actions/bridge.add_theme_color_override("font_color", Color("LIGHT_BLUE"))

func update():
	if game.mine_cooldown > 0:
		$actions/mine.add_theme_color_override("font_color", Color("RED"))
		$actions/mine.set_text(str(game.mine_cooldown))
	else:
		$actions/mine.add_theme_color_override("font_color", Color("LIGHT_BLUE"))
		$actions/mine.set_text("Mine")
	if player.mine_mode:
		$actions/mine.add_theme_color_override("font_color", Color("LIGHT_GREEN"))
		
	if player.bomb_mode:
		$actions/bomb.add_theme_color_override("font_color", Color("LIGHT_GREEN"))
	else:
		$actions/bomb.add_theme_color_override("font_color", Color("LIGHT_BLUE"))
	if game.bombs == 0:
		$actions/bomb.add_theme_color_override("font_color", Color("RED"))
		
	if player.bridge_mode:
		$actions/bridge.add_theme_color_override("font_color", Color("LIGHT_GREEN"))
	else:
		$actions/bridge.add_theme_color_override("font_color", Color("LIGHT_BLUE"))
	if game.bridges == 0:
		$actions/bridge.add_theme_color_override("font_color", Color("RED"))
		
	$actions/bomb.set_text(str("Bomb   [ ", game.bombs, " ]"))
	$actions/bridge.set_text(str("Bridge   [ ", game.bridges, " ]"))
