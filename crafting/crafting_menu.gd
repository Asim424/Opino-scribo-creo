extends Control

class_name Crafting

@export var PlayerBox : TextEdit

var word_dict = ["hello", "scrabble", "bat"]

var special_dict = []

var file_full_dict = FileAccess.open("res://crafting/words.txt", FileAccess.READ)
var content = file_full_dict.get_as_text()

#var file_special_words = FileAccess.open("", FileAccess.READ)
#var special_content = file_special_words.get_as_text()


var L = [
	['░','░','░'],
	['░','∩','░'],
	['░','█','░']
]
var U = [
	[' ',' ',' '],
	[' ',' ',' '],
	[' ',' ',' ']
]

var Unlocked = [
	[L,L,L,L,L,L,L,L,L,L,L],
	[U,L,L,L,L,L,L,L,L,L,L],
	[L,L,L,L,L,L,L,L,L,L,L]
]

var letter_values : Dictionary = {
	'A': 1, 'E': 1, 'I': 1, 'O': 1, 'U': 1, 'L': 1, 'N': 1, 'R': 1, 'S': 1, 'T': 1,
	'D': 2, 'G': 2,
	'B': 3, 'C': 3, 'M': 3, 'P': 3,
	'F': 4, 'H': 4, 'V': 4, 'W': 4, 'Y': 4,
	'K': 5,
	'J': 8, 'X': 8,
	'Q': 10, 'Z': 10
}

var Inventory = {
		'A': 1, 'B': 1, 'C': 0, 'D': 0, 'E': 0, 
		'F': 0, 'G': 0, 'H': 0, 'I': 0, 'J': 0, 
		'K': 0, 'L': 0, 'M': 0, 'N': 0, 'O': 0, 
		'P': 0, 'Q': 0, 'R': 0, 'S': 0, 'T': 1, 
		'U': 0, 'V': 0, 'W': 0, 'X': 0, 'Y': 0, 
		'Z': 0
	}

var Text = []

func _input(event: InputEvent) -> void:
	_on_gui_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	content = content.remove_chars(" ")
	content = content.replace("\r", "")
	word_dict = content.split("\n")
	#print(word_dict)
	#special_content = content.remove_chars(" ")
	#special_content = content.replace("\n", "")
	#special_dict = content.split("\r")
	
	for major_row in Unlocked:
		for row_idx in range(3):
			var full_line = [] 
			
			for block in major_row:
				for char in block[row_idx]:
					full_line.append(char)
			
			Text.append(full_line)
			
			
	#Get the vertical scroll bar node (its name might vary depending on Godot version/structure)
	for child in PlayerBox.get_children():
		if child is VScrollBar:
			PlayerBox.remove_child(child)
		elif child is HScrollBar:
			PlayerBox.remove_child(child)
	PlayerBox.set_overtype_mode_enabled(true)
	var v_scrollbar = PlayerBox.get_v_scroll_bar()
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
	PlayerBox.text = output_text
	LoadInv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_on_text_changed()



var max_lines = 9

func _on_text_changed():
	if PlayerBox.get_line_count() > max_lines:
		# Simple approach: remove last character until line count is valid
		# A more robust approach involves keeping a history of the text
		PlayerBox.text = PlayerBox.text.left(PlayerBox.text.length() - 1)
		# Move cursor to the end
		PlayerBox.set_caret_line(PlayerBox.get_line_count())
	

var showing = false

func _on_gui_input(event: InputEvent) -> void:
	
	if event is InputEventKey and event.is_pressed():
		if event.as_text().to_lower() == "tab":
			
			if showing:
				self.hide()
				self.z_index=-1
				
				showing = false
			else:
				self.show()
				self.z_index=5
				showing = true
	if not showing:
		return
	if event is InputEventKey and event.pressed:
		
		if PlayerBox.get_caret_line() > Text.size()-1 or PlayerBox.get_caret_column() > Text[0].size()-1:
			accept_event()
			return
		if not (Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] == '█' 
		or Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] == '░' 
		or Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] == '∩'):
		# add checker to see if text surpasses that of the array
			if event.keycode == KEY_BACKSPACE:
				# Insert a space instead of deleting
				if Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] != " ":
					Inventory[Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()]] += 1
				Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] = " "
				PlayerBox.set_caret_column(PlayerBox.get_caret_column()+1)
				PlayerBox.backspace()
				PlayerBox.insert_text_at_caret(" ")
				
				PlayerBox.set_caret_column(PlayerBox.get_caret_column()-2)
				# Accept the event to prevent the default deletion behavior
				accept_event()
			if event.keycode == KEY_ENTER:
				PlayerBox.set_caret_line(PlayerBox.get_caret_line()+1)
				accept_event()
				
			if event.keycode == KEY_INSERT:
				accept_event()
				
			if event.as_text().length() == 1:
				if Inventory[event.as_text()] > 0:
					if Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] != " ":
						Inventory[Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()]] += 1
					Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] = event.as_text()
					PlayerBox.set_caret_column(PlayerBox.get_caret_column()+1)
					PlayerBox.backspace()
					PlayerBox.insert_text_at_caret(event.as_text())
					Inventory[event.as_text()] -= 1
				elif event.as_text() == Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()]:
					PlayerBox.set_caret_column(PlayerBox.get_caret_column()+1)
				
				accept_event()
				
			if event.as_text() == "Space":
				#log inv and text changes
				if Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] != " ":
					Inventory[Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()]] += 1
				Text[PlayerBox.get_caret_line()][PlayerBox.get_caret_column()] = " "
				#visual text changes
				PlayerBox.insert_text_at_caret(" ")
				PlayerBox.set_caret_column(PlayerBox.get_caret_column()+1)
				PlayerBox.backspace()
				accept_event()
				
		match event.keycode:
			KEY_UP:
				PlayerBox.set_caret_line(PlayerBox.get_caret_line()-1)
			KEY_DOWN:
				PlayerBox.set_caret_line(PlayerBox.get_caret_line()+1)
			KEY_LEFT:
				PlayerBox.set_caret_column(PlayerBox.get_caret_column()-1)
			KEY_RIGHT:
				PlayerBox.set_caret_column(PlayerBox.get_caret_column()+1)
		accept_event()
		LoadInv()
		get_words_on_board()
		
func LoadInv() -> void:
	var invTxt = ""
	invTxt += "\n"
	var inti = 0
	for i in Inventory:
		if Inventory[i] > 0:
			inti += 1
			invTxt += " " + str(i) + " x " + str(Inventory[i]) + ", "
			if inti%2 == 0:
				invTxt += "\n"
	invTxt += "\n\n\n\n Damage Value : " + str(Damage_Score(validate_words(get_words_on_board())))
	$LetterHolder.text = invTxt

func get_words_on_board():
	var found_words = []
	var board = Text
	var board_size = Text.size()
	# Check Horizontal Words
	for y in range(board_size):
		var current_word = ""
		for x in range(board_size):
			if (board[y][x] != " " and 
			board[y][x] != "░" and
			board[y][x] != "∩" and
			board[y][x] != "█"):
				current_word += board[y][x]
			else:
				if current_word.length() >= 3:
					current_word.remove_chars('░')
					current_word.remove_chars('∩')
					current_word.remove_chars('█')
					found_words.append(current_word)
				current_word = ""
		if current_word.length() >= 3: 
			current_word.remove_chars('░')
			current_word.remove_chars('∩')
			current_word.remove_chars('█')
			found_words.append(current_word)

	# Check Vertical Words (Transpose approach)
	for x in range(board_size):
		var current_word = ""
		for y in range(board_size):
			if (board[y][x] != " " and 
			board[y][x] != "░" and
			board[y][x] != "∩" and
			board[y][x] != "█"):
				current_word += board[y][x]
			else:
				if current_word.length() >= 3:
					current_word.remove_chars('░')
					current_word.remove_chars('∩')
					current_word.remove_chars('█')
					found_words.append(current_word)
				current_word = ""
		if current_word.length() >= 3: 
			current_word.remove_chars('░')
			current_word.remove_chars('∩')
			current_word.remove_chars('█')
			found_words.append(current_word)

	return found_words


func get_letters_on_board():
	var letters = []
	for i in Text:
		for j in i:
			if (j != " " and 
			j != "░" and
			j != "∩" and
			j != "█"):
				letters.append(j)
	return letters

func validate_words(words):
	var valid_found = []
	for word in words:
		if word_dict.has(word.to_lower()):
			valid_found.append(word)
	return valid_found
	


func Damage_Score(words):
	var score = 0
	for word in words:
		for char in word:
			score += letter_values[char] * len(word)/2
	for word in get_letters_on_board():
		for char in word:
			score += letter_values[char]
	return score
