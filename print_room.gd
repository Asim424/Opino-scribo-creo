extends RichTextLabel
class_name printer

var map_generator = map_gen.new()
var map
var room_generator = room_gen.new()
var Player = player.new()
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
	map_generator.generate_map()
	map = map_generator.map.duplicate(true)
	var semi = ""
	
	for i in range(map.size()): # Grid Row (0 to 2)
		for j in range(map[i].size()): # Tile Row (0 to 2)
			var output_text = room_to_ascii(map[i][j])
			if output_text != " ":
				semi += "R"
				output_text = semi +"\n" + output_text
				self.text = output_text
				await get_tree().create_timer(1.0).timeout
			else:
				semi += " "
			#print(j)
		semi += "\n"
	print(semi)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
