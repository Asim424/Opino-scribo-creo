var Unpassable =  [["█","█","█","█","█","█"],
	 ["█","█","█","█","█","█"],
	 ["█","█","█","█","█","█"]]

var fast =  [[" "," "," "," "," "," "], #fast ground
	 [" "," "," "," "," "," "],
	 [" "," "," "," "," "," "]]

var medium =  [["░","║"," "," ","║","░"],#medium ground
	 ["░","╣"," "," ","╠","░"],
	 ["░","║"," "," ","║","░"]]

var slow = [["░"," "," "," "," ","░"], #slow ground
	 ["░","░","▒","▒","░","░"],
	 ["░"," "," "," "," ","░"]]

var door = [["▓","░","▒","░","░","▒"], #door
	 ["▓","░","▒","░","¬","▒"],
	 ["▓","░","▒","░","░","▒"]]

var treasure = [["█","▒","█","█","▒","█"], #treasure
	 ["█","▒","┴","┴","▒","█"],
	 ["▀","▀","▀","▀","▀","▀"]]

var end_wall = [["█","█","█","█","█","█"], # WALL
	 ["█","▒","▒","▒","▒","█"],
	 ["█","█","█","█","█","█"]]
	
var breakable = [["▒","█","░","█","█","░"], # breakable wall
	 ["█","░","▒","▒","░","█"],
	 ["░","█","█","░","█","▒"]]

var spikes = [["^","^","^","^","^","^"], #spikes
	 ["^","^","^","^","^","^"],
	 ["^","^","^","^","^","^"]]

var details = ["#","*","+","_","-","\""] #list of details to randomly place on floor tiles
var rng = RandomNumberGenerator.new()
var body = [[]]
func add_detail():
	for y in range(3):
		for x in range(6):
			if body[y][x] == " " and rng.randi_range(1, 100) <= 4:
				body[y][x] = details.pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
