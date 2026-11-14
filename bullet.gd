extends Area2D

const DEFAULT_SPEED = 45.0

var _speed := DEFAULT_SPEED
var direction := Vector2(randf_range(0, 1) * 10, randf_range(0, 1) * 10) 

@onready var _initial_pos := position
@onready var playingField: ReferenceRect = $"../PlayingField"
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@export var _bounce_direction := 1

func _process(delta: float) -> void:
	
	position += _speed * delta * direction
	var bounds = playingField.get_rect()
	
	var shape_circle = collider.shape as CircleShape2D
	var radius = shape_circle.radius * collider.scale.x * scale.x

	if global_position.x - radius <= bounds.position.x:
		global_position.x = bounds.position.x + radius
		_on_hitting_boundarie(Vector2.RIGHT)
		
	elif global_position.x + radius >= bounds.end.x:
		global_position.x = bounds.end.x - radius
		_on_hitting_boundarie(Vector2.LEFT)
		
	if global_position.y - radius <= bounds.position.y:
		global_position.y = bounds.position.y + radius
		_on_hitting_boundarie(Vector2.DOWN)
		
	elif global_position.y + radius >= bounds.end.y:
		global_position.y = bounds.end.y - radius
		_on_hitting_boundarie(Vector2.UP)
		
func reset() -> void:
	direction = Vector2(randf_range(0, 1) * 10, randf_range(0, 1) * 10) 
	position = _initial_pos
	_speed = DEFAULT_SPEED

func _on_hitting_boundarie(wall_normal: Vector2) -> void:
	direction = direction.bounce(wall_normal)
	
