extends Area2D

@export var speed = 300.0
@onready var playingField: ReferenceRect = $"../PlayingField"
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	reset_player()
	
func reset_player():
	var playfieldPosition = playingField.get_rect().position
	position = playfieldPosition + playingField.get_rect().size / 2

func _process(delta):
	#keep player moving
	var direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	position += direction * speed * delta
	
	#keep Player in Field
	var bounds = playingField.get_rect()
	
	var half_w = (sprite.texture.get_width() * sprite.scale.x) / 2.0
	var half_h = (sprite.texture.get_height() * sprite.scale.y) / 2.0
	
	position.x = clamp(position.x, bounds.position.x + half_w, bounds.end.x - half_w)
	position.y = clamp(position.y, bounds.position.y + half_h, bounds.end.y - half_h)
