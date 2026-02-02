extends RichTextLabel
class_name printer

var map_generator = map_gen.new()
var map
var room_generator = room_gen.new()

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
			if typeof(tile) != TYPE_INT:
				tile_row_height = max(tile_row_height, tile.get_body().size())
			else:
				tile_row_height = max(tile_row_height, 1) # placeholder height

		# Iterate line by line (inside tiles)
		for line_index in tile_row_height:
			var current_line := ""

			for tile in room_row:
				if typeof(tile) != TYPE_INT:
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


# Plug-and-play function for Godot 4 RichTextLabel
# ascii_label: the RichTextLabel node
# ascii_text: your ASCII art (multiline string)
# char_aspect: tweak if ASCII looks stretched horizontally



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var room = room_generator.gen_room(3,[])
	map_generator.generate_map()
	map = map_generator.map.duplicate(true)
	var i = 0
	var m = 0
	#for i in range(map.size()): # Grid Row (0 to 2)
		#for m in range(map[i].size()): # Tile Row (0 to 2)
	var current_line = ""
	var output_text = room_to_ascii(room)
	#if room is not String:
		#var tile_height = room[0][0].get_body().size()  # Usually 3 rows per tile
		#var tile_width = room[0][0].get_body()[0].size()  # Usually 6 columns per tile
#
	#for j in range(room.size()):  # Room row (vertical)
		## For each row inside the tiles
		#for l in range(tile_height):
			#current_line = ""
			#for n in range(room[j].size()):  # Room column (horizontal)
				#var tile = room[j][n]
				#if not tile is int:
					## Append the corresponding row of the tile
					#current_line += "".join(str(c) for c in tile.get_body()[l])
				#else:
					#current_line += "LLL"  # Placeholder for int tiles
			#output_text += current_line + "\n"

	#for room in map[0][0]:
		#for tile_row in room:
			#for y in range(3):
				#for tile in tile_row:
					#for x in range(6):
						#current_line += tile[y][x]
				#output_text += current_line + "\n"
				
	self.text = output_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
