extends Node2D

@export var WeaponSprite : RichTextLabel
@export var hitBox : Area2D
@export var playerParent : RichTextLabel
@export var AnimPlayer : AnimationPlayer

var weaponInactive : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
				KEY_UP:
					self.show()
					AnimPlayer.play("SwingUP")

				KEY_DOWN:
					self.show()
					AnimPlayer.play("SwingDOWN")

				KEY_LEFT:
					self.show()
					AnimPlayer.play("SwingLEFT")

				KEY_RIGHT:
					self.show()
					AnimPlayer.play("SwingRIGHT")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if AnimPlayer.is_playing() == false:
		self.hide()
	self.position.x = playerParent.position.x + (playerParent.room_position[1]+.5)*13*3
	self.position.y = playerParent.position.y + (playerParent.room_position[0]+.75)*13*3
