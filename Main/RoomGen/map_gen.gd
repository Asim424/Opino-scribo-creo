extends Node2D
class_name map_gen
var rng = RandomNumberGenerator.new()

#from the floor figure out how big
#make the start and end rooms, and a line between them
#add x rooms to the sides of the path
var floor_num = 1
var total_rooms = 9 + floor(floor_num* 10/3)
var map = [['']]
var start_loc = [-2,-2]
var treasure_loc = []
var shop_loc = [-1,-1]
var room_generator = room_gen.new()
var player_map
func get_map():
	return map

func generate_map(parent):
	rng.randomize()
	map = [["START"]]
	player_map = []
	total_rooms = 9 + floor(floor_num* 10/3)
	start_loc = [-2,-2]
	treasure_loc = []
	shop_loc = [-1,-1]
	var boss_loc = []
	room_generator = room_gen.new()
	map[0][0] = ["START"]
	var last_location = [0,0]
	while total_rooms > 0:
		total_rooms -= 1
		var random = rng.randi_range(0,3)
		var stuck = 0
		match random:
			0:
				if last_location[1]-1 >= 0:
					if not map[last_location[1]-1][last_location[0]] is Array:
						map[last_location[1]-1][last_location[0]] = [""]
						last_location[1] -= 1
					else:
						stuck +=1
						if stuck == 4:
							map[last_location[1]][last_location[0]] = [""]
							last_location[1] -= 1
							stuck = 0
				else:
					var temp = [""]
					temp.resize(len(map[0]))
					temp.fill(" ")
					map.insert(0,temp)
					map[0][last_location[0]] = [""]
					last_location[1] = 0
					
			1:
				if last_location[1]+1 < len(map):
					if not map[last_location[1]+1][last_location[0]] is Array:
						map[last_location[1]+1][last_location[0]] = [""]
						last_location[1] += 1
					else:
						stuck +=1
						if stuck == 4:
							map[last_location[1]][last_location[0]] = [""]
							last_location[1] += 1
							stuck = 0
				else:
					var temp = [""]
					temp.resize(len(map[last_location[1]]))
					temp.fill(" ")
					temp[last_location[0]] = [""]
					map.insert(0,temp)
					
			2:
				if last_location[0]+1 < len(map[last_location[1]]):
					if not map[last_location[1]][last_location[0]+1] is Array:
						map[last_location[1]][last_location[0]+1] = [""]
						last_location[0] += 1
					else:
						stuck +=1 
						if stuck == 4:
							map[last_location[1]][last_location[0]] = [""]
							last_location[0] += 1
							stuck = 0
				else:
					for i in range(map.size()):
						map[i].append(" ")
					map[last_location[1]][last_location[0]+1] = [""]
					last_location[0]+=1
					
					
			3:
				if last_location[0]-1 >= 0:
					if not map[last_location[1]][last_location[0]-1] is Array:
						map[last_location[1]][last_location[0]-1] = [""]
						last_location[0] -= 1
						
					else:
						stuck += 1
						if stuck == 4:
							last_location[0] -= 1
							map[last_location[1]][last_location[0]] = [""]
							stuck = 0
				else:
					for i in range(map.size()):
						map[i].insert(0," ")
					map[last_location[1]][last_location[0]] = [""]
					
				
		
			
		pass

	#add a treasure room
	for x in range(len(map[-1])-1,-1,-1):
		if map[-1][x] is Array:
			var temp = []
			temp.resize(x+1)
			temp.fill(" ")
			treasure_loc = [len(map),x]
			temp[-1] = room_generator.gen_room(1,parent, [],[x,len(map)],floor_num)
			map.append(temp)
			break

			
	#add a shop
	
	var sides = randi_range(1,3)
	var entrances = []
	var longest = [0,0]
	var potential = 0
	for i in range(len(map)):
		for j in range(len(map[i])):
			if map[i][j] is Array:
				potential += 1
		if potential > longest[1]:
			longest[0] = i
			longest[1] = potential
		potential = 0
	
			
	if shop_loc == [-1,-1]:
		if map[longest[0]][-1] is Array:
			map[longest[0]].append(" ")
		shop_loc = [map[longest[0]].size()-1,longest[0]]
		map[longest[0]][-1] = room_generator.gen_room(2,parent,["W"],shop_loc,floor_num)
	
	for x in range(len(map[0])):
		if map[0][x] is Array:
			var temp = []
			temp.resize(x+1)
			temp.fill(" ")
			boss_loc = [0,x]
			temp[x] = room_generator.gen_room(3 ,parent, ["S"],[x,0],floor_num)
			temp[x][7][8] = boss.new()
			var temp2 = Basic_types.new()
			temp2.set_body(2)
			temp[x][7][8].tile_below = temp2
			temp[x][7][8].HP = 50*floor_num
			temp[x][7][8].spawn_hitbox(parent)						
			temp[x][7][8].disable_hit()
			temp[x][7][8].room_position = [7,8]
			temp[x][7][8].map_position = boss_loc.duplicate()

			treasure_loc[0] += 1
			shop_loc[1] += 1
			
			map.insert(0,temp)
			break
		
	for i in range(len(map)):
		for j in range(len(map[i])):
			entrances = []
			if map[i][j] is Array:
				if map[i][j][0] is String:
					if map[i][j][0] == "START":
						start_loc = [j,i]
						map[i][j] = [""]
			if i-1 >= 0:
				if j < len(map[i-1]):
					if map[i-1][j] is Array and [j,i-1] != shop_loc:
						entrances.append("N")
			if i+1 < len(map):
				if j < len(map[i+1]):
					if map[i+1][j] is Array and [j,i+1] != shop_loc:
						entrances.append("S")
			if j-1 >= 0:
				if map[i][j-1] is Array:
					entrances.append("W")
			if j+1 < len(map[i]):
				if map[i][j+1] is Array:
					entrances.append("E")
			if map[i][j] is Array and [i,j] != treasure_loc and [j,i] != shop_loc and [i,j] != boss_loc:
				map[i][j] = room_generator.gen_room(3,parent,entrances, [j,i],floor_num).duplicate(true)
			elif [i,j] == treasure_loc:
				map[i][j] = room_generator.gen_room(1,parent,entrances, [j,i],floor_num).duplicate(true)
			elif [j,i] == shop_loc:
				map[i][j] = room_generator.gen_room(2,parent,entrances, [j,i],floor_num).duplicate(true)
			
	print("player makes issues")
	player_map = start_loc.duplicate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
