extends Node2D

@onready var playing_field: ReferenceRect = $"../PlayingField"
@export var bullet_scene: PackedScene

func spawn_bullets_for_level(level: int) -> void:
	clear_all_bullets()
	var bounds = playing_field.get_rect()
	
	for i in range(level):
		var new_bullet = bullet_scene.instantiate()
		new_bullet.playingField = playing_field
		new_bullet.position = bounds.position + Vector2(50 + i * 40, 50)
		add_child(new_bullet)
	
func clear_all_bullets() -> void:
	for b in get_tree().get_nodes_in_group("bullets"):
		b.queue_free()
		
func set_bullets_active(is_active: bool) -> void:
	for b in get_tree().get_nodes_in_group("bullets"):
		b.set_process(is_active)

func start_blinking_all() -> void:
	for b in get_tree().get_nodes_in_group("bullets"):
		b.start_blinking()
