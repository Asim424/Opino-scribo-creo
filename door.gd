extends Node2D
class_name door
var body = [["▓","░","▒","░","░","▒"], #door
	 ["▓","░","▒","░","¬","▒"],
	 ["▓","░","▒","░","░","▒"]]
var map_coordinates = [1,1]
var room_coordinates = [1,1]
var direction_exit = ["N"] #"S","E","W"

# Called when the node enters the scene tree for the first time.
func get_body():
	return body
	

func set_map_coords(coord : Array):
	map_coordinates = coord.duplicate(true)

func set_room_coords(coord : Array):
	room_coordinates = coord.duplicate(true)
	if room_coordinates[0] == 14:
		room_coordinates[0] = 1
	elif room_coordinates[0] == 0:
		room_coordinates[0] = 13
	if room_coordinates[1] == 0:
		room_coordinates[1] = 15
	elif room_coordinates[1] == 16:
		room_coordinates[1] = 1
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
