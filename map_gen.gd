extends Node2D
class_name map_gen
var rng = RandomNumberGenerator.new()

#from the floor figure out how big
#make the start and end rooms, and a line between them
#add x rooms to the sides of the path
var floor_num = 1
var special_rooms_left = [5,1,2]
var total_rooms = 9 + floor(floor_num* 10/3)
var map = [['']]
var start_loc
var treasure_loc = []
var room_generator = room_gen.new()

func get_map():
	return map

func generate_map():
	map[0][0] = []
	var last_location = [0,0]
	while total_rooms > 0:
		total_rooms -= 1
		match rng.randi_range(0,3):
			0:
				if last_location[1]-1 >= 0:
					if not map[last_location[1]-1][last_location[0]] is Array:
						map[last_location[1]-1][last_location[0]] = []
						last_location[1] -= 1
					else:
						total_rooms += 1
				else:
					var temp = []
					temp.resize(len(map[0]))
					temp.fill(" ")
					map.append(temp)
					map[0][last_location[0]] = []
					last_location[1] = 0
			1:
				if last_location[1]+1 < len(map):
					if not map[last_location[1]+1][last_location[0]] is Array:
						map[last_location[1]+1][last_location[0]] = []
						last_location[1] += 1
					else:
						total_rooms += 1
				else:
					var temp = []
					temp.resize(len(map[0]))
					temp.fill(" ")
					map.insert(-1,temp)
					map[0][last_location[0]] = []
					last_location[1] += 1
					
			2:
				if last_location[0]+1 < len(map[last_location[1]]):
					if not map[last_location[1]][last_location[0]+1] is Array:
						map[last_location[1]][last_location[0]+1] = []
					else:
						total_rooms += 1
				else:
					map[last_location[1]].insert(-1,[])
					
			3:
				if last_location[0]-1 >= 0:
					if not map[last_location[1]][last_location[0]-1] is Array:
						map[last_location[1]][last_location[0]-1] = []
						last_location[0] -= 1
					else:
						total_rooms += 1
				else:
					map[0].append([])
					last_location[0] = 0
					
			
		pass

	#add a treasure room
	for x in range(len(map[-1])):
		if 1 in special_rooms_left:
			var temp = room_generator.gen_room(1,[])
			map[-1][x] = temp.duplicate(true)
			treasure_loc = [len(map),x]
			special_rooms_left.erase(1)
			
	#add a shop
	while 2 in special_rooms_left:
		for i in range(len(map)):
			for j in range(len(map[i])):
				var entrances = []
				if  rng.randi_range(1,10) == 1:
					if j-1 >= 0:
						if map[i][j-1] is Array and [i,j] != treasure_loc:
							entrances.append("W")
					if j+1 < len(map[i]):
						if map[i][j+1] is Array and [i,j] != treasure_loc:
							entrances.append("E")
					special_rooms_left.erase(2)
	
				
	for i in range(len(map)):
		for j in range(len(map[i])):
			var entrances = []
			if i-1 >= 0:
				if j < len(map[i-1]):
					if map[i-1][j] is Array:
						entrances.append("N")
			if i+1 < len(map):
				if j < len(map[i+1]):
					if map[i+1][j] is Array and [i,j] != treasure_loc:
						entrances.append("S")
			if j-1 >= 0:
				if map[i][j-1] is Array and [i,j] != treasure_loc:
					entrances.append("W")
			if j+1 < len(map[i]):
				if map[i][j+1] is Array and [i,j] != treasure_loc:
					entrances.append("E")
			if map[i][j] is Array:
				map[i][j] = room_generator.gen_room(3,entrances).duplicate(true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
