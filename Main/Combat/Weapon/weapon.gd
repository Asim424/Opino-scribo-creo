extends Node2D

@export var WeaponSprite : RichTextLabel
@export var hitBox : Area2D
@export var playerParent : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position.x = playerParent.room_position[1]*16
	self.position.y = playerParent.room_position[0]*16
