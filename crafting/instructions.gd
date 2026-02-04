extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the vertical scroll bar node (its name might vary depending on Godot version/structure)
	var v_scrollbar = self.get_v_scroll_bar()
	if v_scrollbar:
		v_scrollbar.modulate.a = 0 # Set alpha to 0 to hide it
		# Or make it non-interactable
		v_scrollbar.mouse_filter = MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
