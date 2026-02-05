extends Node

class_name basicE
var HP = 10
var max_HP = 10
var room_position = [7,8]
var map_position = [0,0]
var alr_moved = false
var area
var col : CollisionShape2D
var parent
var body = [["[color=green]┌","┬","┬","┬","┬","┐[/color]"], #enemy character 
	 ["[color=green]├","┼","\\","┼","/","┤[/color]"],
	 ["[color=green]└","┴","┴","┴","┴","┘[/color]"]]
@export var room : RichTextLabel
	
var tile_below
var curr_weapon
var map = []
var weapon = [[]]

func choose_weapon():
	pass

func get_body():
	return body

func get_map() -> Array:
	return map

func spawn_hitbox(dad) -> void:
	area = Area2D.new()
	parent = dad
	parent.add_child(area)

	col = CollisionShape2D.new()
	area.add_child(col)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(13 * 3, 13 * 3)
	col.shape = shape
	area.area_entered.connect(_on_area_entered)
	move_hitbox()

func _on_area_entered(body: Node) -> void:
	if body.get_parent().get_parent() is Weapon:
		take_damage(body.get_parent().get_parent().damage)

func take_damage(damage):
	HP -=  damage
	if HP <= 0:
		get_room()[room_position[0]][room_position[1]] = tile_below
		for i in area.get_children():
			i.queue_free()
		area.queue_free()
		self.queue_free()
		parent.print_room()
		parent.coins += 1
		
	

func disable_hit():
	col.set_deferred("disabled",true)
	area.set_deferred("disabled",true)
	area.position.x = 1000
	area.position.y = 1000

func enable_hit():
	col.set_deferred("disabled",false)
	area.set_deferred("disabled",false)


func move_hitbox():
	area.position.x = (room_position[1]+.5)*13*3
	area.position.y = (room_position[0]+.75)*13*3
	enable_hit()



func move_enemies(player_pos : Array):
	if room_position[0] < player_pos[0]:
		move("S")
	elif room_position[0] > player_pos[0]:
		move("N")
	elif room_position[1] > player_pos[1]:
		move("W")
	elif room_position[1] < player_pos[1]:
		move("E")

func get_room() -> Array:
	return map[map_position[1]][map_position[0]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move(direction : String):
	var x = 0
	var y = 0
	match direction:
		"N": y = -1
		"S": y = 1
		"E": x = 1
		"W": x = -1
	if get_room()[room_position[0]+y][room_position[1]+x] is Basic_types:	#walls, floors, nothing special
		#print(get_room()[room_position[0]+y][room_position[1]+x].type)
		if get_room()[room_position[0]+y][room_position[1]+x].type in [1,5]:	#check if its a wall
			return
		else:
			if not alr_moved:
				alr_moved = true
				get_room()[room_position[0]][room_position[1]] = tile_below		#replace player with the tile its standing on rn
				tile_below = get_room()[room_position[0]+y][room_position[1]+x]		#stores next tile 
				get_room()[room_position[0]+y][room_position[1]+x] = self		#replaces next tile with player
				room_position[0] += y	#set player position
				room_position[1] += x
	
