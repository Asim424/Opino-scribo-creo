extends TextEdit

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
	[L,L,L,L,L,L,L,L,L],
	[U,L,L,L,L,L,L,L,L],
	[L,L,L,L,L,L,L,L,L]
]

func _input(event: InputEvent) -> void:
	_on_gui_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get the vertical scroll bar node (its name might vary depending on Godot version/structure)
	for child in self.get_children():
		if child is VScrollBar:
			self.remove_child(child)
		elif child is HScrollBar:
			self.remove_child(child)
	self.set_overtype_mode_enabled(true)
	var v_scrollbar = self.get_v_scroll_bar()
	self.scroll_v_scroll_speed = 0
	if v_scrollbar:
		v_scrollbar.modulate.a = 0 # Set alpha to 0 to hide it
		# Or make it non-interactable
		v_scrollbar.mouse_filter = MOUSE_FILTER_IGNORE
		v_scrollbar.ANCHOR_END
	var output_text = ""
	for i in range(Unlocked.size()): # Grid Row (0 to 2)
		for m in range(3): # Tile Row (0 to 2)
			var current_line = ""
			for j in range(Unlocked[i].size()): # Grid Column (0 to 3)
				for n in range(3): # Tile Column (0 to 2)
					# Build the physical line by appending characters horizontally
					current_line += str(Unlocked[i][j][m][n])
			output_text += current_line + "\n"
			
	# Update the Godot Node (works for TextEdit or RichTextLabel)
	output_text.capitalize()
	self.text = output_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_on_text_changed()



var max_lines = 9

func _on_text_changed():
	if get_line_count() > max_lines:
		# Simple approach: remove last character until line count is valid
		# A more robust approach involves keeping a history of the text
		text = text.left(text.length() - 1)
		# Move cursor to the end
		set_caret_line(get_line_count())
	
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BACKSPACE:
			# Insert a space instead of deleting
			backspace()
			insert_text_at_caret(" ")
			set_caret_column(get_caret_column()-1)
			# Accept the event to prevent the default deletion behavior
			accept_event()
		if event.keycode == KEY_ENTER:
			set_caret_line(get_caret_line()+1)
			accept_event()
		if event.keycode == KEY_INSERT:
			accept_event()
		
		
