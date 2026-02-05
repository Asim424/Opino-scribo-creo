extends Node2D

class_name Weapon

@export var WeaponSprite : RichTextLabel
@export var hitBox : Area2D
@export var hitBoxBounds : CollisionShape2D
@export var playerParent : RichTextLabel
@export var AnimPlayer : AnimationPlayer
@export var CraftingMenu : Crafting
var damage = 0
var weaponInactive : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateText()
	self.hide()
	
func updateText() -> void:
	var text = ""
	var longestLine = ""
	var lines = 0
	for i in CraftingMenu.Text:
		var current_line : String = ""
		for j in i:
			if not (j == '█' 
			or j == '░' 
			or j == '∩'):
				current_line+=j
				if current_line.length() > longestLine.length():
					var spaceless = current_line.remove_chars(" ")
					longestLine = spaceless
		var spaceless = current_line.remove_chars(" ")
		if spaceless != "":
			text += current_line+"\n"
			lines += 1
	WeaponSprite.text = text
	hitBoxBounds.shape.size.x = longestLine.length()*16
	hitBoxBounds.shape.size.y = lines*16
	hitBox.position.x = longestLine.length()*12
	hitBox.position.y = lines*12
	print(longestLine + " : " + str(lines))

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_echo():
			return
		match event.keycode:
				KEY_UP:
					self.show()
					weaponInactive = false
					AnimPlayer.play("SwingUP")
					hitBox.set_deferred("disabled",false)
					hitBoxBounds.set_deferred("disabled",false)

				KEY_DOWN:
					self.show()
					weaponInactive = false
					AnimPlayer.play("SwingDOWN")
					hitBox.set_deferred("disabled",false)
					hitBoxBounds.set_deferred("disabled",false)

				KEY_LEFT:
					self.show()
					weaponInactive = false
					AnimPlayer.play("SwingLEFT")
					hitBox.set_deferred("disabled",false)
					hitBoxBounds.set_deferred("disabled",false)

				KEY_RIGHT:
					self.show()
					weaponInactive = false
					AnimPlayer.play("SwingRIGHT")
					hitBox.set_deferred("disabled",false)
					hitBoxBounds.set_deferred("disabled",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if AnimPlayer.is_playing() == false:
		hitBox.set_deferred("disabled",true)
		hitBoxBounds.set_deferred("disabled",true)
		weaponInactive = true
		self.hide()
	self.position.x = playerParent.position.x + (playerParent.room_position[1]+.5)*13*3
	self.position.y = playerParent.position.y + (playerParent.room_position[0]+.75)*13*3
