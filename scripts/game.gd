extends Node2D

@onready var tilemap : TileMapLayer = $TileMap
@onready var cursor = $Cursor


var mouse_pressed = false  # if the mouse is pressed right now
var break_time = 1  # Time to hold to break the block in seconds
var current_time = 0.0  # Current time holding the mouse
var is_breaking = false # if a block is getting broken right now
var world_mouse_pos = null # mouse position right now
var tile_pos = null # the position of the tile the mouse is on in the tile map 
var player_pos = null # current player position
var range_player_tile = null # range between the player and the tile the mouse is on right now


func _process(delta: float): # runs constantly
	world_mouse_pos = $Player/Camera2D.get_global_mouse_position()
	tile_pos = tilemap.local_to_map(world_mouse_pos)
	player_pos = tilemap.local_to_map($Player.position)
	range_player_tile = floor(sqrt((abs(player_pos.x - tile_pos.x) * abs(player_pos.x - tile_pos.x)) + (abs(player_pos.y - tile_pos.y) * abs(player_pos.y - tile_pos.y))))
	cursor.set_pos(tile_pos)
	
	# checks if tile your mouse is pressed on right now is breakable and starts breaking if so
	if tilemap.get_cell_source_id(tile_pos) != -1 and mouse_pressed == true and range_player_tile < $Player.reach:
		is_breaking = true
	
	# if breaking a valid block, adjusts the cursor texture to show breaking 
	if mouse_pressed == true and is_breaking == true and range_player_tile < $Player.reach and tilemap.get_cell_source_id(tile_pos) != -1:
		
		if (current_time / break_time) > 0.8:
			cursor.set_breaking_cursor(2)
		elif (current_time / break_time) > 0.4:
			cursor.set_breaking_cursor(1)
		elif (current_time / break_time) > 0:
			cursor.set_breaking_cursor(0)
		current_time += delta
	else:
		cursor.set_breaking_cursor(-1)
		is_breaking = false
		current_time = 0.0
		
	# if enough time has passed, breaks the block
	if current_time >= break_time:
		tilemap.erase_cell(tile_pos)
		current_time = 0.0
		is_breaking = false
		cursor.set_breaking_cursor(-1)



func _input(event: InputEvent): # runs when an input happends
	
	if event is InputEventMouseButton and event.pressed: # when mouse is pressed
		if event.button_index == MOUSE_BUTTON_LEFT: # left mouse button
			world_mouse_pos = $Player/Camera2D.get_global_mouse_position()
			mouse_pressed = true
			tile_pos = tilemap.local_to_map(world_mouse_pos)
			
			# if pressed block is valid, starts breaking
			if range_player_tile < $Player.reach and tilemap.get_cell_source_id(tile_pos) != -1:
				is_breaking = true
				current_time = 0.0
	
	elif event is InputEventMouseButton and not event.pressed: # when mouse is released resets everything
		mouse_pressed = false
		is_breaking = false
		current_time = 0.0
		
	if event is InputEventMouseMotion: # when the mouse is moved
		world_mouse_pos = $Player/Camera2D.get_global_mouse_position()
		
		if mouse_pressed == true:
			
			# checks if the block the mouse is on is air and stops breaking
			if tilemap.get_cell_source_id(tilemap.local_to_map(world_mouse_pos)) == -1:
				is_breaking = false
				current_time = 0.0
				tile_pos = tilemap.local_to_map(world_mouse_pos)
			# checks if the block youre looking at is different from the block we were breaking and starts breaking if in reach
			elif tile_pos != tilemap.local_to_map(world_mouse_pos):
					current_time = 0.0
					if range_player_tile < $Player.reach:
						is_breaking = true
					tile_pos = tilemap.local_to_map(world_mouse_pos)
	
	# press TAB to remove cursor
	if event.is_action_pressed("draw_cursor"):
		cursor.draw_cursor()
		
