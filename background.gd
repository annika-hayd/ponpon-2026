extends Node2D


@export var insert_pixel: float = 70.0
@export var animation_duration: float = 0.8

@onready var coin: Sprite2D = $Coin
@onready var _coin_start_pos: Vector2 = $Coin.position

func insert_coin() -> void:
	reset_coin()
	
	var tween = create_tween()
	tween.tween_property(coin, "position:x", _coin_start_pos.x - insert_pixel, animation_duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	coin.hide()

func reset_coin() -> void:
	coin.position = _coin_start_pos
	coin.show()
