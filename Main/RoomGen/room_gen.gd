class_name room_gen

var W := Basic_types.new()
var S := Basic_types.new()
var M := Basic_types.new()
var F := Basic_types.new()
var U := Basic_types.new()
var rng = RandomNumberGenerator.new()
var body = []

func grab_tile(position:Array, direction:String):
	match direction:
		"N":
			if position[1] > 0:
				return body[position[1]-1][position[0]]
		"S":
			if position[1] < len(body):
				return body[position[1]+1][position[0]]
		"E":
			if position[0] > 0:
				return body[position[1]][position[0]-1]
		"W":
			if position[0] < len(body[0]):
				return body[position[1]][position[0]+1]
	return -1
#IDs: 1 = door 2 = treasure 3 = breakable 4 = spike 5 = shopkeep 6 = shop item
#top left coord = [0,0], [x,y]
func get_room():
	return body


func add_detail(body):
	var details = ["#","*","+","_","-","\""] #list of details to randomly place on floor tiles
	for tile_row in body:
		for tile in tile_row:
			for y in range(3):
				for x in range(6):
					if tile is Basic_types:
						if tile.get_body()[y][x] == " " and rng.randi_range(1, 100) <= 1:
							tile.get_body()[y][x] = details.pick_random()

func instantiate_room(room, coords = []):
	var out = []
	for y in range(room.size()):
		var row = []
		if room[y] is Array:
			for x in range(room[y].size()):
				var cell = room[y][x]
				if cell is int:
					if cell == 1:
						var Door = door.new()
						var spawn = [y,x]
						var temp_coords = coords.duplicate()
						if x == 16:
							temp_coords[0] += 1
						if x == 0:
							temp_coords[0] -= 1
						if y == 0:
							temp_coords[1] -= 1
						if y == 14:
							temp_coords[1] += 1
						Door.set_map_coords(temp_coords)
						# Example destination logic
						#var next_room = pick_next_room_id(current_room_id) #do this in map_gen

						Door.set_room_coords(spawn)
						row.append(Door)
					
					elif cell == 2:
						var Treasure = treasure.new()
						Treasure.set_inside()
						row.append(Treasure)
					elif cell == 3:
						var Breakable = breakable.new()
						row.append(Breakable)
						
					elif cell == 4:
						var Spike = spike.new()
						#set damage in map_gen, damage is based on floor
						row.append(Spike)
						
					elif cell == 5:
						var Shopkeeper = shopkeeper.new()
						row.append(Shopkeeper)
						
					elif cell == 6:
						var Shop = shop.new()
						Shop.set_inside()
						row.append(Shop)
				else:
					var temp = randi_range(0,100)
					if temp <= 1 and cell.type in [2,3,4,6]:
						var enemy = basicE.new()
						enemy.room_position = [y,x]
						enemy.map_position = coords.duplicate()
						enemy.tile_below = cell
						enemy.spawn_hitbox()
						row.append(enemy)
					else:
						row.append(cell)
			out.append(row)
	return out

func gen_room(choice, sides: Array, coords : Array = []):#when doing treasure, sides does not matter
	#when doing shop, sides has to be either ["E"], ["W"] or ["E","W"]
	#when doing 2x2, sides has to be in the form ["SE","WN"] etc, 
	#first letter is the wall, 2nd is where on the wall
	match choice:
		1: #treasure
			var temp = rng.randi_range(1,42)
			for i in range(len(treasure_rooms)):
				temp = temp - treasure_rooms[i][-1]
				if temp <= 0:
					var temp2 = treasure_rooms[i].duplicate(true)
					for y in range(temp2.size()):
						if temp2[y] is Array:
							for x in range(temp2[y].size()):
								if temp2[y][x] is Basic_types:
									temp2[y][x] = temp2[y][x].copy()
					body = temp2
					body = instantiate_room(body, coords)
					add_detail(body)
					return body
			return "hahaha"
			
		2: #shop
			
			var temp2 = shop_room.duplicate(true)
			for y in range(temp2.size()):
				if temp2[y] is Array:
					for x in range(temp2[y].size()):
						if temp2[y][x] is Basic_types:
							temp2[y][x] = temp2[y][x].copy()
			body = temp2
			if sides.has("E"):
				body[7][16] = 1
			if sides.has("W"):
				body[7][0] = 1
			body = instantiate_room(body, coords)
			add_detail(body)
			return body
		3: #empty 1X1
			var temp2 = empty_room.duplicate(true)
			for y in range(temp2.size()):
				if temp2[y] is Array:
					for x in range(temp2[y].size()):
						if temp2[y][x] is Basic_types:
							temp2[y][x] = temp2[y][x].copy()
			body = temp2
			if sides.has("E"):
				body[7][16] = 1
			if sides.has("W"):
				body[7][0] = 1
			if sides.has("N"):
				body[0][8] = 1
			if sides.has("S"):
				body[14][8] = 1
			body = instantiate_room(body, coords)
			add_detail(body)
			return body
		4: #empty 2x2
			return [[]]
		5: #boss
			return [[]]

func _init() -> void:
	U.set_body(1)
	F.set_body(2)
	M.set_body(3)
	S.set_body(4)
	W.set_body(5)
var treasure_rooms = [
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,2,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,3,M,2,M,3,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,U,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,U,S,M,M,M,F,M,M,M,S,U,U,S,W],
[W,S,S,U,S,M,M,M,F,M,M,M,S,U,U,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,U,U,U,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,U,U,U,U,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W],
[W,S,S,S,S,U,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,U,S,M,2,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,3,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,S,S,3,S,M,M,M,F,M,M,M,S,S,U,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,S,3,S,S,M,M,M,2,M,M,M,S,U,3,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,U,U,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,U,U,U,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,U,U,U,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,U,3,U,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,U,U,U,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,F,F,F,M,M,S,S,S,S,W],
[W,S,S,S,S,M,2,F,3,F,2,M,S,S,S,S,W],
[W,S,S,S,S,M,M,F,F,F,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W], # give this a lower chace to show up
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],2.1],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,U,U,U,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,U,U,S,S,M,M,M,F,M,M,M,S,U,U,U,W],
[W,U,U,S,S,M,M,M,F,M,M,M,S,S,S,U,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,2,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,U,S,S,S,S,S,M,M,M,S,S,S,S,U,U,W],
[W,U,U,S,S,S,S,S,M,S,S,S,S,U,U,U,W],
[W,U,U,U,S,S,S,S,S,S,S,S,S,U,U,U,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,4,4,4,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,4,4,4,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,4,4,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,3,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,3,S,W],
[W,S,S,S,S,M,M,M,2,M,M,M,S,S,3,S,W],
[W,S,S,S,S,M,M,M,M,M,M,M,S,S,S,S,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,4,4,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,4,4,4,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,4,4,4,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,4,4,4,M,M,4,4,4,M,M,S,S,S,S,W],
[W,S,4,2,4,M,M,4,2,4,M,M,S,S,S,S,W],
[W,S,4,4,4,M,M,4,3,4,M,M,S,S,S,S,W],
[W,S,S,S,S,S,M,M,M,M,M,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],5.4],
[[W,W,W,W,W,W,W,W,1,W,W,W,W,W,W,W,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,M,M,F,M,M,M,S,S,S,S,W],
[W,S,S,S,S,M,3,3,3,3,3,M,S,S,S,S,W],
[W,S,S,S,S,M,3,3,3,3,3,M,S,S,S,S,W],
[W,S,S,S,S,M,3,3,3,3,3,M,S,S,S,S,W], # make this very rare
[W,S,S,S,S,S,3,3,3,3,3,S,S,S,S,S,W],
[W,S,S,S,S,S,S,M,M,M,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,M,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],2.1],
]
var shop_room = [
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,S,S,S,M,M,M,M,5,M,M,M,M,S,S,S,W],
[W,S,S,M,M,M,M,M,M,M,M,M,M,M,S,S,W],
[W,S,M,M,M,M,6,M,6,M,6,M,M,M,M,S,W],
[W,M,M,M,M,M,F,M,F,M,F,M,M,M,M,M,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,M,M,M,M,M,F,M,F,M,F,M,M,M,M,M,W],
[W,S,M,M,M,M,6,M,6,M,6,M,M,M,M,S,W],
[W,S,S,M,M,M,M,M,M,M,M,M,M,M,S,S,W],
[W,S,S,S,M,M,M,M,M,M,M,M,M,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W]]

var empty_room = [
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,W],
[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W]]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
