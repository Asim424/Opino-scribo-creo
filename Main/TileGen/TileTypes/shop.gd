extends Node2D
class_name shop

var randLetter := rand_letter.new()
var contents : String
var price = 15
var L = "a"
var body = [["▓","▓","▓","▓","▓","▓"], #item for sale
	 ["▓","▓", L , L ,"▓","▓"], # shop gives you a choice of one of two items
	 ["▓","▓","▓","▓","▓","▓"]] #dynamically replace bottom row with price

func get_body():
	return body


func _init():
	contents = randLetter.get_letter()
	L = contents
	if L in  ["j","k","q","x","z"," "]:
		price = 30
	body = [["▓","▓","▓","▓","▓","▓"], #item for sale
	 ["▓","▓", L , L ,"▓","▓"], # shop gives you a choice of one of two items
	 ["▓","▓","▓","▓","▓","▓"]] #dynamically replace bottom row with price
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
