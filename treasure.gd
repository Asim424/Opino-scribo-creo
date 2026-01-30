extends Node2D
class_name treasure
var body = [["█","▒","█","█","▒","█"], #treasure
	 ["█","▒","┴","┴","▒","█"],
	 ["▀","▀","▀","▀","▀","▀"]]

var contents := rand_letter.new()

func set_inside():
	contents = contents.get_letter()
	

func open():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
