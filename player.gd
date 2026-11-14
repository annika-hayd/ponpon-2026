extends Area2D

@export var speed = 400.0
@onready var playingField: ReferenceRect = $"../PlayingField"
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var playfieldPosition = playingField.get_rect().position
	position = playfieldPosition + playingField.get_rect().size /2
	speed = 5
	
func _input(event):
	var velocity = Vector2.ZERO
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_D:
			velocity = Vector2(position.x+speed,position.y)
			print(position.x)
		if event.keycode == KEY_A:
			velocity = Vector2(position.x-speed,position.y)
			print(position.x)
		if event.keycode == KEY_W:
			velocity = Vector2(position.x,position.y-speed)
			print(position.y)
		if event.keycode == KEY_S:
			velocity = Vector2(position.x,position.y+speed)
			print(position.y)	

		position = velocity
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var bounds = playingField.get_rect()
	
	var half_w = (sprite.texture.get_width() * sprite.scale.x) / 2.0
	var half_h = (sprite.texture.get_height() * sprite.scale.y) / 2.0
	print("With: " , sprite.texture.get_width(), " Scale X: " , sprite.scale.x)
	print("Height: " , sprite.texture.get_height(), " Scale Y: " , sprite.scale.y)
	# 4. Position begrenzen
	position.x = clamp(position.x, bounds.position.x + half_w, bounds.end.x - half_w)
	position.y = clamp(position.y, bounds.position.y + half_h, bounds.end.y - half_h)

	
