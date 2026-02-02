extends Control
class_name player
var HP = 10
var max_HP = 10
var room_position = [0,0]
var map_position = [0,0]
var body = [["╔","═","/","\\","═","╗"], #player character 
	 ["║","@","_","_","@","║"],
	 ["╚","═","═","═","═","╝"]]
var tile_below
var curr_weapon

func move():
	pass
	#store the tile you will move onto in a temp variable
	#store current coordinates in a temp variable
	#set the coordinates and facing direction to the new location
	#replace the tile you will move onto with a copy of this player object
	#replace this player object with the tile in tile_below
	#delete this player object in case it is still active to avoid memory leak

func attack():
	pass
	#spawn new text box with the hitboxes
	#rotate based on direction input
	#maybe change facing direction
	#delete textbox once animation is complete
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
