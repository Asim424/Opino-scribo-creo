extends RichTextLabel

class_name player
var HP = 10
var max_HP = 10
var room_position = [7,8]
var coins = 0
var map_position = [0,0]
var body = [["╔","═","/","\\","═","╗"], #player character 
	 ["║","@","_","_","@","║"],
	 ["╚","═","═","═","═","╝"]]
var tile_below
var curr_weapon
var map = []
var map_generator = map_gen.new()
var weapon = [[]]
var father = self

@export var crafting : Crafting

func get_body():
	return body

func get_map() -> Array:
	return map

func get_room() -> Array:
	return map[map_position[1]][map_position[0]]

func room_clear():
	for i in range(map[map_position[1]][map_position[0]].size()):
		for j in range(map[map_position[1]][map_position[0]][i].size()):
			if map[map_position[1]][map_position[0]][i][j] is basicE or map[map_position[1]][map_position[0]][i][j] is boss:
				return false
	return true

func enemies_disable():
	for i in range(map[map_position[1]][map_position[0]].size()):
			for j in range(map[map_position[1]][map_position[0]][i].size()):
				if map[map_position[1]][map_position[0]][i][j] is basicE or map[map_position[1]][map_position[0]][i][j] is boss:
					map[map_position[1]][map_position[0]][i][j].disable_hit()
func move_enemies():
	for i in range(map[map_position[1]][map_position[0]].size()):
		for j in range(map[map_position[1]][map_position[0]][i].size()):
			if map[map_position[1]][map_position[0]][i][j] is basicE or map[map_position[1]][map_position[0]][i][j] is boss:
				map[map_position[1]][map_position[0]][i][j].map = map
				map[map_position[1]][map_position[0]][i][j].move_enemies(room_position)
			elif map[map_position[1]][map_position[0]][i][j] is breakable:
				map[map_position[1]][map_position[0]][i][j].map = map
				map[map_position[1]][map_position[0]][i][j].move_hitbox()
				
	for i in range(map[map_position[1]][map_position[0]].size()):
		for j in range(map[map_position[1]][map_position[0]][i].size()):
			if map[map_position[1]][map_position[0]][i][j] is basicE or map[map_position[1]][map_position[0]][i][j] is boss:
				map[map_position[1]][map_position[0]][i][j].move_hitbox()
				map[map_position[1]][map_position[0]][i][j].alr_moved = false

func move(direction : String):
	var x = 0
	var y = 0
	match direction:
		"N": y = -1
		"S": y = 1
		"E": x = 1
		"W": x = -1
	if get_room()[room_position[0]+y][room_position[1]+x] is Basic_types:	#walls, floors, nothing special
		if get_room()[room_position[0]+y][room_position[1]+x].type in [1,5]:	#check if its a wall
			return
		else:
			get_room()[room_position[0]][room_position[1]] = tile_below		#replace player with the tile its standing on rn
			tile_below = get_room()[room_position[0]+y][room_position[1]+x]		#stores next tile 
			get_room()[room_position[0]+y][room_position[1]+x] = self		#replaces next tile with player
			room_position[0] += y	#set player position
			room_position[1] += x
	elif get_room()[room_position[0]+y][room_position[1]+x] is door:		#doors
		if room_clear():
			var temp  = get_room()[room_position[0]+y][room_position[1]+x].copy()	#store door
			get_room()[room_position[0]][room_position[1]] = tile_below		#replace player with tile it was standing on
			enemies_disable()
			map_position = temp.map_coordinates		#door points to the new position for the player
			room_position = temp.room_coordinates
			tile_below = get_room()[room_position[0]][room_position[1]]		#store next tile
			get_room()[room_position[0]][room_position[1]] = self		#move player
			print_room()	#then show the room
			return
	elif get_room()[room_position[0]+y][room_position[1]+x] is treasure:
		crafting.Inventory[get_room()[room_position[0]+y][room_position[1]+x].contents.to_upper()] += 1
		get_room()[room_position[0]+y][room_position[1]+x] = Basic_types.new()
		get_room()[room_position[0]+y][room_position[1]+x].set_body(2)
	elif get_room()[room_position[0]+y][room_position[1]+x] is shop and get_room()[room_position[0]+y][room_position[1]+x].price <= coins:
		crafting.Inventory[get_room()[room_position[0]+y][room_position[1]+x].contents.to_upper()] += 1
		coins -= get_room()[room_position[0]+y][room_position[1]+x].price
		get_room()[room_position[0]+y][room_position[1]+x] = Basic_types.new()
		get_room()[room_position[0]+y][room_position[1]+x].set_body(2)
	elif get_room()[room_position[0]+y][room_position[1]+x] is spike:
		damage(get_room()[room_position[0]+y][room_position[1]+x].damage)
		get_room()[room_position[0]][room_position[1]] = tile_below		#replace player with the tile its standing on rn
		tile_below = get_room()[room_position[0]+y][room_position[1]+x]		#stores next tile 
		get_room()[room_position[0]+y][room_position[1]+x] = self		#replaces next tile with player
		room_position[0] += y	#set player position
		room_position[1] += x
	elif get_room()[room_position[0]+y][room_position[1]+x] is trap:
		map_generator.floor_num += 1
		room_position = [7,8]
		reset()
		return
	move_enemies()
	print_room()	#then show the room
	print_map()
	
func damage(ouch):
	HP -= ouch
	print(HP)	#then show the room
	
	if HP <= 0:
		print("death")
	#if tile_below is door:
		#map_position = tile_below.map_coordinates
		#room_position = tile_below.room_cordinates
	#store the tile you will move onto in a temp variable
	#store current coordinates in a temp variable
	#set the coordinates and facing direction to the new location
	#replace the tile you will move onto with a copy of this player object
	#replace this player object with the tile in tile_below
	#delete this player object in case it is still active to avoid memory leak

func attack(direction : String):
	await get_tree().create_timer(0.5).timeout
	print_room()	#then show the room
	move_enemies()
	print_room()	#then show the room
	
	#print_map()
	pass
	#spawn new text box with the hitboxes
	#rotate based on direction input
	#maybe change facing direction
	#delete textbox once animation is complete
	
# Called when the node enters the scene tree for the first time.

func reset():
	map_generator.generate_map(father)
	map = map_generator.map.duplicate(true)
	map_position = map_generator.player_map.duplicate()
	tile_below = map[map_position[1]][map_position[0]][7][8]
	map[map_position[1]][map_position[0]][7][8] = self
	print_room()
	
func _init() -> void:
	map_generator.generate_map(father)
	map = map_generator.map.duplicate(true)
	map_position = map_generator.player_map.duplicate()
	tile_below = map[map_position[1]][map_position[0]][7][8]
	map[map_position[1]][map_position[0]][7][8] = self
	print_room()
	# Replace with function body.


func _input(event):
	if event.is_action_pressed("W"):
		move("N")
	if event.is_action_pressed("A"):
		move("W")
	if event.is_action_pressed("S"):
		move("S")
	if event.is_action_pressed("D"):
		move("E")
	if event.is_action_pressed("ui_text_caret_up"):
		attack("N")
	if event.is_action_pressed("ui_text_caret_down"):
		attack("S")
	if event.is_action_pressed("ui_text_caret_left"):
		attack("W")
	if event.is_action_pressed("ui_text_caret_right"):
		attack("E")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func print_map():
	var temp = ""
	for i in range(map.size()):
		for j in range(map[i].size()):
			if [j,i] == map_position:
				temp += "H"
			elif map[i][j] is not String:
				temp += "R"
			else:
				temp += " "
		temp += "\n"
	print(temp)
	return temp
	

				
func print_room():
	var output_text = "\n" + room_to_ascii(map[map_position[1]][map_position[0]])
	if output_text != " ":
		self.parse_bbcode(output_text)


func print_coins():
	return "coins: "+str(coins)

func room_to_ascii(room) -> String:
	if typeof(room) == TYPE_STRING:
		return room  # Already ASCII

	var output_text := ""

	# Number of rows of tiles in the room
	var room_rows = room.size()

	for row_index in room_rows:
		var room_row = room[row_index]

		# Determine tallest tile in this row
		var tile_row_height := 0
		for tile in room_row:
			if typeof(tile) != TYPE_INT and tile != null:
				tile_row_height = max(tile_row_height, tile.get_body().size())
			else:
				tile_row_height = max(tile_row_height, 1) # placeholder height

		# Iterate line by line (inside tiles)
		for line_index in tile_row_height:
			var current_line := ""

			for tile in room_row:
				if typeof(tile) != TYPE_INT and tile != null:
					var tile_body = tile.get_body()
					if line_index < tile_body.size():
						for char in tile_body[line_index]:
							current_line += str(char)
					else:
						# pad with spaces if tile shorter than tallest
						var width := 1
						if tile_body.size() > 0:
							width = tile_body[0].size()
						current_line += " ".repeat(width)
				else:
					current_line += "LLL"  # placeholder for int tiles

			output_text += current_line + "\n"

	return output_text
