extends Node2D
class_name shop

var contents := rand_letter.new()
var price = 15
var L = "a"
var body = [["▓","▓","▓","▓","▓","▓"], #item for sale
	 ["▓","▓", L , L ,"▓","▓"], # shop gives you a choice of one of two items
	 ["▓","▓","▓","▓","▓","▓"]] #dynamically replace bottom row with price
func set_inside():
	L = contents.get_letter()
	if L in  ["j","k","q","x","z"," "]:
		price = 30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
