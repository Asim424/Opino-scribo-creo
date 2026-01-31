extends Node2D
class_name map_gen
var rng = RandomNumberGenerator.new()

#from the floor figure out how big
#make the start and end rooms, and a line between them
#add x rooms to the sides of the path
var floor_num = 1
var special_rooms_left = [5,1,2,3]
var total_rooms = 9 + floor(floor_num* 10/3)
var map = [['']]
var start_loc
func generate_map():
	map[0][0] = room_gen.new()
	var last_location = [0,0]
	var direction = ""
	while total_rooms > 0:
		total_rooms -= 1
		match rng.randi_range(0,3):
			0:
				direction = "N"
				if last_location[1]-1 >= 0:
					if not map[last_location[1]-1][last_location[0]] is room_gen:
						map[last_location[1]-1][last_location[0]] = room_gen.new()
						last_location[1] -= 1
					else:
						total_rooms += 1
				else:
					var temp = []
					temp.resize(len(map[0]))
					temp.fill(" ")
					map.append(temp)
					map[0][last_location[0]] = room_gen.new()
					last_location[1] -= 1
			1:
				direction = "S"
				if last_location[1]+1 < len(map):
					if not map[last_location[1]+1][last_location[0]] is room_gen:
						map[last_location[1]+1][last_location[0]] = room_gen.new()
						last_location[1] += 1
					else:
						total_rooms += 1
				else:
					var temp = []
					temp.resize(len(map[0]))
					temp.fill(" ")
					map.insert(-1,temp)
					map[-1][last_location[0]] = room_gen.new()
					last_location[1] += 1
					
			2:
				direction = "E"
				if last_location[0]+1 < len(map[0]):
					if not map[last_location[1]][last_location[0]+1] is room_gen:
						map[last_location[1]][last_location[0]+1] = room_gen.new()
						last_location[0] += 1
						
					else:
						total_rooms += 1
				else:
					map[0].insert(-1," ")
					map[last_location[1]][-1] = room_gen.new()
					last_location[0] += 1
					
			3:
				direction = "W"
				if last_location[0]-1 >= 0:
					if not map[last_location[1]][last_location[0]-1] is room_gen:
						map[last_location[1]][last_location[0]-1] = room_gen.new()
						last_location[0] -= 1
					else:
						total_rooms += 1
				else:
					map[0].append(" ")
					map[last_location[1]][0] = room_gen.new()
					last_location[0] -= 1
					
			4:
				if not special_rooms_left.is_empty():
					var temp = [special_rooms_left.pick_random()]
					map[last_location[1]][last_location[0]] = temp
					special_rooms_left.erase(temp)
		pass
	for i in range(len(map)):
		for j in range(len(map[i])):
			var entrances = []
			if i-1 >= 0:
				if map[i-1][j] != " ":
					entrances.append("N")
			if i+1 < len(map):
				if map[i+1][j] != " ":
					entrances.append("S")
			if j-1 >= 0:
				if map[i][j-1] != " ":
					entrances.append("W")
			if j+1 < len(map[i]):
				if map[i][j-1] != " ":
					entrances.append("E")
			if map[i][j] is room_gen:
				map[i][j].gen_room(3,entrances)
			else:
				var temp = map[i][j]
				map[i][j] = room_gen.new()
				map[i][j].gen_room(temp,entrances)
				if temp == 3:
					start_loc = [j,i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
