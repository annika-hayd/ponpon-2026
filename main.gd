extends Node

enum State { TITLE, DIALOG, PLAYING, GAME_OVER, GAME_END }
var current_state: State = State.TITLE

var current_level: int = 1
var max_levels: int = 3
var bullet_blinking_seconds: float = 5.0

@onready var ui: CanvasLayer = $UI
@onready var level_timer: Timer = $LevelTimer
@onready var player: Area2D = $Player
@onready var bullet_spawner: Node2D = $BulletSpawner
@onready var background = $Background

func _ready() -> void:
	# Verbindet die eigenen Signale aus ui.gd automatisch per Code:
	ui.start_pressed.connect(_on_ui_start_pressed)
	ui.next_dialog_pressed.connect(_on_ui_next_dialog_pressed)
	ui.try_again_pressed.connect(_on_ui_try_again_pressed)
	
	change_state(State.TITLE)

func change_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.TITLE:
			level_timer.stop()
			current_level = 1
			bullet_spawner.clear_all_bullets()
			background.reset_coin()
			set_gameplay_active(false)
			ui.show_title()
			
		State.DIALOG:
			level_timer.stop()
			set_gameplay_active(false)
			bullet_spawner.clear_all_bullets()
			player.reset_player()
			ui.show_dialog(current_level)
			
		State.PLAYING:
			ui.hide_all()
			bullet_spawner.spawn_bullets_for_level(current_level)
			set_gameplay_active(true)
			level_timer.start(15.0)
			
		State.GAME_END:
			level_timer.stop()
			set_gameplay_active(false)
			bullet_spawner.clear_all_bullets()
			ui.show_game_end()
			
		State.GAME_OVER:
			level_timer.stop()
			set_gameplay_active(false)
			bullet_spawner.clear_all_bullets()
			ui.show_game_over()

func set_gameplay_active(is_active: bool) -> void:
	player.set_process(is_active)
	bullet_spawner.set_bullets_active(is_active)

func _process(_delta: float) -> void:
	if current_state == State.PLAYING:
		if level_timer.time_left <= bullet_blinking_seconds and level_timer.time_left > 0.0:
			bullet_spawner.start_blinking_all()

func progress_in_story() -> void:
	if current_state == State.PLAYING:
		current_level += 1
		if current_level > max_levels:
			change_state(State.GAME_END)
		else:
			change_state(State.DIALOG)

# --- SIGNALE ---
func _on_ui_start_pressed() -> void:
	await background.insert_coin()
	change_state(State.DIALOG)

func _on_ui_next_dialog_pressed() -> void:
	change_state(State.PLAYING)

func _on_ui_try_again_pressed() -> void:
	change_state(State.TITLE)
	
func _on_level_timer_timeout() -> void:
	progress_in_story()

func _on_player_area_entered(area: Area2D) -> void:
	if current_state == State.PLAYING and area.is_in_group("bullets"):
		change_state(State.GAME_OVER)
