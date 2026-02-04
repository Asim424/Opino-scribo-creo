extends Node

var F = [[" "," "," "," "," "," "], #fast ground
[" "," "," "," "," "," "],
[" "," "," "," "," "," "]]
var M = [["▒"," "," "," "," ","▒"],#medium ground
[" ","▒","▒","▒","▒"," "],
["▒"," "," "," "," ","▒"]]
var S = [["▓"," "," "," "," ","▓"], #slow ground
[" ","▓","▓","▓","▓"," "],
["▓"," "," "," "," ","▓"]]

var D = [["█","▓","█","▒","█","█"], #door
["░","█","▓","█","█","¬"],
["█","█","▓","█","▒","█"]]

var T = [["█","▒","█","█","▒","█"], #treasure
["█","▒","┴","┴","▒","█"],
["█","▒","▒","▒","▒","█"]]

var TL = [["█","█","█","█","█","█"], # top left corner
	  ["█","█","x"," ","+","x"],
	  ["█","█"," ","0"," "," "]]
var TO = [["█","█","█","█","█","█"], # top wall
	  ["+"," ","x"," ","*"," "],
	  [" "," "," ","#"," "," "]]
var TR = [["█","█","█","█","█","█"], # top right corner
	  [" ","*"," ","+","█","█"],
	  [" "," "," "," ","█","█"]]
var L =  [["█","█"," "," "," "," "], # left wall
	  ["█","█"," ","0"," "," "],
	  ["█","█","x"," ","+"," "]]
var R =  [["+"," "," ","*","█","█"], # right wall
	  [" "," ","0"," ","█","█"],
	  [" "," "," ","x","█","█"]]
var BL = [["█","█"," ","0"," "," "],
	  ["█","█","*"," ","+"," "],
	  ["█","█","█","█","█","█"]] # bottom left corner
var B =  [[" "," "," ","x"," "," "],
	  ["0"," ","+"," "," "," "],
	  ["█","█","█","█","█","█"]] # bottom wall
var BR = [[" ","0"," ","+","█","█"],
	  ["#"," ","x"," ","█","█"],
	  ["█","█","█","█","█","█"]] # bottom right corner
var rooms = [[[TL,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TR],
[L,S,S,S,S,M,M,M,D,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,T,M,M,M,S,S,S,S,R],
[L,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,R],
[L,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,R],
[L,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,R],
[L,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,R],
[L,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,R],
[L,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,R],
[BL,B,B,B,B,B,B,B,B,B,B,B,B,B,B,B,BR]]
]
func print_rooms():
	for room in rooms:
		for tile_row in room:
			for y in range(3):
				for tile in tile_row:
					for x in range(6):
						print(tile[y][x])
					print()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(rooms[0])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
