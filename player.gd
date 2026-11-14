extends Area2D

@export var speed = 5.0
@onready var playingField: ReferenceRect = $"../PlayingField"
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	var playfieldPosition = playingField.get_rect().position
	position = playfieldPosition + playingField.get_rect().size / 2
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_D:
			position.x += speed
		elif event.keycode == KEY_A:
			position.x -= speed
		elif event.keycode == KEY_W:
			position.y -= speed
		elif event.keycode == KEY_S:
			position.y += speed

func _process(delta):
	var bounds = playingField.get_rect()
	
	var half_w = (sprite.texture.get_width() * sprite.scale.x) / 2.0
	var half_h = (sprite.texture.get_height() * sprite.scale.y) / 2.0
	
	# Position begrenzen
	position.x = clamp(position.x, bounds.position.x + half_w, bounds.end.x - half_w)
	position.y = clamp(position.y, bounds.position.y + half_h, bounds.end.y - half_h)
