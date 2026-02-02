class_name room_gen

var W := Basic_types.new()
var S := Basic_types.new()
var M := Basic_types.new()
var F := Basic_types.new()
var U := Basic_types.new()
var rng = RandomNumberGenerator.new()
var body = []
#IDs: 1 = door 2 = treasure 3 = breakable 4 = spike 5 = shopkeep 6 = shop item
#top left coord = [0,0], [x,y]
func get_room():
	return body
func add_detail(body):
	var details = ["#","*","+","_","-","\""] #list of details to randomly place on floor tiles
	for y in range(3):
		for x in range(6):
			if body[y][x] == " " and rng.randi_range(1, 100) <= 4:
				body[y][x] = details.pick_random()

func instantiate_room(room):
	var out = []
	for y in range(room.size()):
		var row = []
		for x in range(room[y].size()):
			var cell = room[y][x]

			if cell == 1:
				var Door = door.new()
				
				# Example destination logic
				#var next_room = pick_next_room_id(current_room_id) #do this in map_gen
				var spawn = [x,y]

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
				row.append(cell)
		out.append(row)
	return out

func gen_room(choice, sides: Array):#when doing treasure, sides does not matter
	#when doing shop, sides has to be either ["E"], ["W"] or ["E","W"]
	#when doing 2x2, sides has to be in the form ["SE","WN"] etc, 
	#first letter is the wall, 2nd is where on the wall
	match choice:
		1: #treasure
			var temp = rng.randi_range(1,43)
			for i in range(len(treasure_rooms)):
				temp = temp - treasure_rooms[i][-1]
				if temp <= 0:
					body = treasure_rooms[i].duplicate(true)
					instantiate_room(body)
					add_detail(body)
					body.pop_back()
					return body
			
		2: #shop
			body = shop_room.duplicate(true)
			if sides.has("E"):
				body[8][16] = 1
			if sides.has("W"):
				body[8][0] = 1
			if sides.has("N"):
				body[0][8] = 1
			if sides.has("S"):
				body[14][8] = 1
			instantiate_room(body)
			add_detail(body)
			body.pop_back()
			return body
		3: #empty 1X1
			body = empty_room.duplicate(true)
			if sides.has("E"):
				body[8][16] = 1
			if sides.has("W"):
				body[8][0] = 1
			if sides.has("N"):
				body[0][8] = 1
			if sides.has("S"):
				body[14][8] = 1
			instantiate_room(body)
			add_detail(body)
			body.pop_back()
			return body
		4: #empty 2x2
			pass
		5: #boss
			pass

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
