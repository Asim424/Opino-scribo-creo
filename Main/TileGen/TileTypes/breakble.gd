extends Node2D
class_name breakable

var HP = 10
var max_HP = 10
var room_position = [7,8]
var map_position = [0,0]
var alr_moved = false
var area
var col : CollisionShape2D
var parent
var map

var body =  [["▒","█","░","█","█","░"], # breakable wall
	 ["█","░","▒","▒","░","█"],
	 ["░","█","█","░","█","▒"]]
var broken =  [["░","▒"," ","▒","▒"," "], # breakable wall
   			   ["▒"," ","░","░"," ","▒"],
			   [" ","▒","▒"," ","▒","░"]]
# Called when the node enters the scene tree for the first time.
var is_broken = false
var has_coin = false

func get_body():
	return body

func make_coin():
	has_coin = true

func destroy():
	body = broken.duplicate(true)
	is_broken = true
func _ready() -> void:
	pass # Replace with function body.

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

func get_room() -> Array:
	return map[map_position[1]][map_position[0]]
	
func take_damage(damage):
	HP -=  damage
	if HP <= 0:
		get_room()[room_position[0]][room_position[1]] = Basic_types.new()
		get_room()[room_position[0]][room_position[1]].set_body(6)
		for i in area.get_children():
			i.queue_free()
		area.queue_free()
		self.queue_free()
		parent.print_room()
		parent.coins += 1
		

func move_hitbox():
	area.position.x = (room_position[1]+.5)*13*3
	area.position.y = (room_position[0]+.75)*13*3
	enable_hit()
	
func _on_area_entered(body: Node) -> void:
	if body.get_parent().get_parent() is Weapon:
		take_damage(body.get_parent().get_parent().damage)


func disable_hit():
	col.set_deferred("disabled",true)
	area.set_deferred("disabled",true)
	area.position.x = 1000
	area.position.y = 1000

func enable_hit():
	col.set_deferred("disabled",false)
	area.set_deferred("disabled",false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
