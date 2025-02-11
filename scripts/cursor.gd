extends Node


@export var tilemap : TileMapLayer
@export var draw : bool = true

@export var breaking_texture_0 : Texture2D
@export var breaking_texture_1 : Texture2D
@export var breaking_texture_2 : Texture2D
@export var cursor_texture : Texture2D

# function for making cursor invisible
func draw_cursor():
	if $".".visible == true:
		$".".visible = false
	else:
		$".".visible = true
	
# fucntion for setting the cursors position
func set_pos(tile_pos):
	var pixel_pos = Vector2(int(tile_pos.x * 32 + 16), int(tile_pos.y * 32 + 16)) 
	$".".position = pixel_pos
	
	
# function for setting the cursors texture
func set_breaking_cursor(variation: int):
	
	if variation == -1:
		$".".texture = cursor_texture
	elif variation == 0:
		$".".texture = breaking_texture_0
	elif variation == 1:
		$".".texture = breaking_texture_1
	elif variation == 2:
		$".".texture = breaking_texture_2
