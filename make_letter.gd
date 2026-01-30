extends Node2D
class_name rand_letter
var rng = RandomNumberGenerator.new()

func get_letter():
	var value = rng.randi_range(1,100)
	if value in range(10):
		return "a"
	elif value in range(10,12):
		return "b"
	elif value in range(12,14):
		return "c"
	elif value in range(14,18):
		return "d"
	elif value in range(18,30):
		return "e"
	elif value in range(30,32):
		return "f"
	elif value in range(32,35):
		return "g"
	elif value in range(35,37):
		return "h"
	elif value in range(37,46):
		return "i"
	elif value in range(46,47):
		return "j"
	elif value in range(47,48):
		return "k"
	elif value in range(48,52):
		return "l"
	elif value in range(52,54):
		return "m"
	elif value in range(54,60):
		return "n"
	elif value in range(60,68):
		return "o"
	elif value in range(68,70):
		return "p"
	elif value in range(70,71):
		return "q"
	elif value in range(71,77):
		return "r"
	elif value in range(77,81):
		return "s"
	elif value in range(81,87):
		return "t"
	elif value in range(87,89):
		return "u"
	elif value in range(89,91):
		return "v"
	elif value in range(91,93):
		return "w"
	elif value in range(93,94):
		return "x"
	elif value in range(94,96):
		return "y"
	elif value in range(96,99):
		return "z"
	elif value in range(99,101):
		return " "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
