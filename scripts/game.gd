extends Node2D


var tile_breaking_pos = null
var mouse_pressed = false
var break_time = 0.5  # Time to hold to break the block in seconds
var current_time = 0.0  # Current time holding the mouse
var is_breaking = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var world_mouse_pos = $Player/Camera2D.get_global_mouse_position()
			tile_breaking_pos = $TileMap.local_to_map(world_mouse_pos)
			
			
			
	
	
func _process(delta: float):
	var world_mouse_pos = $Player/Camera2D.get_global_mouse_position()
	var tile_pos = $TileMap.local_to_map(world_mouse_pos)
	var player_pos = $TileMap.local_to_map($Player.position)
	var range_player_tile = floor(sqrt((abs(player_pos.x - tile_pos.x) * abs(player_pos.x - tile_pos.x)) + (abs(player_pos.y - tile_pos.y) * abs(player_pos.y - tile_pos.y))))

	if Input.is_action_pressed("mouse_left"):
		
		if is_breaking == false:
			is_breaking = true
			current_time = 0.0
			
		if tile_pos != tile_breaking_pos:
			current_time = 0.0
			tile_breaking_pos = tile_pos
			
		current_time += delta
		
		if current_time >= break_time:
			if range_player_tile < $Player.reach:
				$TileMap.erase_cell(tile_pos)
				current_time = 0.0
				is_breaking = false
	#print(str(tile_pos) + " | " + str(tile_breaking_pos) + str(is_breaking) + str(range))
	
