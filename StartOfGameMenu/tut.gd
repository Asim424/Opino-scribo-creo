extends Control

@export var sprite : Sprite2D

@export var img1 : Sprite2D
@export var img2 : Sprite2D
@export var img3 : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var i = 0
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		i += 1
		if i == 1:
			sprite.queue_free()
		elif i == 2:
			img1.queue_free()
		elif i == 3:
			img2.queue_free()
		elif i == 4:
			self.queue_free()
	accept_event()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
