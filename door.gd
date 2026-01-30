extends Node2D
class_name door
var body = [["▓","░","▒","░","░","▒"], #door
	 ["▓","░","▒","░","¬","▒"],
	 ["▓","░","▒","░","░","▒"]]
var map_coordinates = [1,1]
var room_cordinates = [1,1]
var direction_exit = ["N"] #"S","E","W"
# Called when the node enters the scene tree for the first time.
func set_room_coords(coord : Array):
	room_cordinates = coord.duplicate(true)
	if room_cordinates[1] == 0:
		room_cordinates[1] = 1
	elif room_cordinates[1] == 14:
		room_cordinates[1] = 13
	elif room_cordinates[0] == 0:
		room_cordinates[0] = 1
	elif room_cordinates[0] == 16:
		room_cordinates[0] = 15
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
