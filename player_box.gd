extends GridContainer

var L = [
	['▓','▓','▓'],
	['▓','∩','▓'],
	['▓','█','▓']
]
var U = [
	[' ',' ',' '],
	[' ',' ',' '],
	[' ',' ',' ']
]

var Unlocked = [
	L,L,L,L,L,
	U,L,L,L,L,
	L,L,L,L,L
]

var WeaponText

# Called when the node enters the scene tree for the first time.
func _ready():
# Get the vertical scroll bar node (its name might vary depending on Godot version/structure)
	#for child in self.get_children():
		#if child is VScrollBar:
			#self.remove_child(child)
		#elif child is HScrollBar:
			#self.remove_child(child)
	#self.set_overtype_mode_enabled(true)
	#var v_scrollbar = self.get_v_scroll_bar()
	#self.scroll_v_scroll_speed = 0
	#if v_scrollbar:
		#v_scrollbar.modulate.a = 0 # Set alpha to 0 to hide it
		## Or make it non-interactable
		#v_scrollbar.mouse_filter = MOUSE_FILTER_IGNORE
		#v_scrollbar.ANCHOR_END
	#var output_text = ""
	#for i in range(Unlocked.size()): # Grid Row (0 to 2)
		#for m in range(3): # Tile Row (0 to 2)
			#var current_line = ""
			#for j in range(Unlocked[i].size()): # Grid Column (0 to 3)
				#for n in range(3): # Tile Column (0 to 2)
					## Build the physical line by appending characters horizontally
					#current_line += str(Unlocked[i][j][m][n])
			#output_text += current_line + "\n"
			#
	## Update the Godot Node (works for TextEdit or RichTextLabel)
	#self.text = output_text
	var playerBoxes = self.get_children()
	print(range(playerBoxes.size()))
	for i in range(playerBoxes.size()):
		print(Unlocked[i])
		if Unlocked[i] == L:
			var output_text = ""
			for j in L:
				var current_line = ""
				for m in j:
					current_line += m
				output_text += current_line + "\n"
			var box : TextEdit = playerBoxes[i]
			box.text = output_text
			box.editable = false
			box.selecting_enabled = false
			
		elif Unlocked[i] == U:
			var output_text = ""
			for j in U:
				var current_line = ""
				for m in j:
					current_line += m
				output_text += current_line + "\n"
			playerBoxes[i].text = output_text
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
