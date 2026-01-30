extends Node2D
class_name breakable

var body =  [["▒","█","░","█","█","░"], # breakable wall
	 ["█","░","▒","▒","░","█"],
	 ["░","█","█","░","█","▒"]]
var broken =  [["░","▒"," ","▒","▒"," "], # breakable wall
   			   ["▒"," ","░","░"," ","▒"],
			   [" ","▒","▒"," ","▒","░"]]
# Called when the node enters the scene tree for the first time.
var is_broken = false
var has_coin = false

func make_coin():
	has_coin = true

func destroy():
	body = broken.duplicate(true)
	is_broken = true
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
