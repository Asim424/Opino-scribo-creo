extends Node2D
class_name treasure
var body = [["█","▒","█","█","▒","█"], #treasure
	 ["█","▒","┴","┴","▒","█"],
	 ["▀","▀","▀","▀","▀","▀"]]

var random_letter := rand_letter.new()
var contents = ""

func get_body():
	return body

func set_inside():
	contents = random_letter.get_letter()


func open():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init() -> void:
	set_inside()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
