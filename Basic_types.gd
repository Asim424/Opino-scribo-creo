class_name Basic_types
static var Unpassable =  [["█","█","█","█","█","█"],
	 ["█","█","█","█","█","█"],
	 ["█","█","█","█","█","█"]]

static var fast =  [[" "," "," "," "," "," "], #fast ground
	 [" "," "," "," "," "," "],
	 [" "," "," "," "," "," "]]

static var medium =  [["░","║"," "," ","║","░"],#medium ground
	 ["░","╣"," "," ","╠","░"],
	 ["░","║"," "," ","║","░"]]

static var slow = [["░"," "," "," "," ","░"], #slow ground
	 ["░","░","▒","▒","░","░"],
	 ["░"," "," "," "," ","░"]]

static var end_wall = [["█","█","█","█","█","█"], # WALL
	 ["█","▒","▒","▒","▒","█"],
	 ["█","█","█","█","█","█"]]

static var broken_wall =  [["░","▒"," ","▒","▒"," "], # broken wall
   			   ["▒"," ","░","░"," ","▒"],
			   [" ","▒","▒"," ","▒","░"]]

var body = [[]]
func set_body(choice):
	match choice:
		1: body = Unpassable.duplicate(true)
		2: body = fast.duplicate(true)
		3: body = medium.duplicate(true)
		4: body = slow.duplicate(true)
		5: body = end_wall.duplicate(true)
		6: body = broken_wall.duplicate(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
