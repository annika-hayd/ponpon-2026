extends Node

enum State { TITLE, DIALOG, PLAYING, GAME_OVER, GAME_END }
var current_state: State = State.TITLE

var current_level: int = 1
var max_levels: int = 3
var bulletBlinkingSeconds = 5

@export var bullet_scene: PackedScene

@onready var title_screen: Control = $UI/TitleScreen
@onready var dialog_box: Control = $UI/DialogBox
@onready var dialog_label: Label = $UI/DialogBox/Dialog
@onready var game_over_screen: Control = $UI/GameOverScreen
@onready var game_end_screen: Control = $UI/GameEndScreen
@onready var playing_field: ReferenceRect = $PlayingField
@onready var level_timer: Timer = $LevelTimer
@onready var player: Area2D = $Player
@onready var bullet: Area2D = $Bullet

func _ready() -> void:
	change_state(State.TITLE)

func change_state(new_state: State) -> void:
	current_state = new_state
	
	title_screen.hide()
	dialog_box.hide()
	game_over_screen.hide()
	game_end_screen.hide()
	
	match current_state:
		State.TITLE:
			current_level = 1
			clear_all_bullets()
			set_gameplay_active(false)
			title_screen.show()
			
		State.DIALOG:
			set_gameplay_active(false)
			clear_all_bullets()
			player.reset_player() 
			show_dialog_for_level(current_level)
			dialog_box.show()
			
		State.PLAYING:
			spawn_bullets_for_level(current_level)
			set_gameplay_active(true)
			level_timer.start(15.0) #+ current_level * 5.0 to increase the timer per level
			
		State.GAME_END:
			set_gameplay_active(false)
			clear_all_bullets()
			game_end_screen.show()
			
		State.GAME_OVER:
			set_gameplay_active(false)
			clear_all_bullets()
			game_over_screen.show()

# --- DIALOG --- (maybe later as XML?)
func show_dialog_for_level(level: int) -> void:
	match level:
		1:
			dialog_label.text = "Welcome to this Game, this is a initial Dialog,\n  klick 'next' for starting the game"
		2:
			dialog_label.text = "HA! You lost this level.. or maybe won...\n at least you've been hit by the bullet!"
		3:
			dialog_label.text = "How do you like that?\n This is your last chance!!\n Good luck!"

# --- BULLETS SPAWNEN & AUFRÄUMEN ---
func spawn_bullets_for_level(level: int) -> void:
	clear_all_bullets()
	var bounds = playing_field.get_rect()
	
	for i in range(level):
		var new_bullet = bullet_scene.instantiate()
		new_bullet.position = bounds.position + Vector2(50 + i * 40, 50)
		add_child(new_bullet)
	
func clear_all_bullets() -> void:
	for b in get_tree().get_nodes_in_group("bullets"):
		b.queue_free()

func set_gameplay_active(is_active: bool) -> void:
	player.set_process(is_active)
	for b in get_tree().get_nodes_in_group("bullets"):
		b.set_process(is_active)

# --- SIGNALEs form BUTTONS & COLLISION ---

func _on_start_button_pressed() -> void:
	change_state(State.DIALOG)

func _on_next_dialog_button_pressed() -> void:
	change_state(State.PLAYING)
	
func progress_in_Story() -> void:
	if current_state == State.PLAYING:
		current_level += 1
		
		if current_level > max_levels:
			change_state(State.GAME_END)
		else:
			change_state(State.DIALOG)

func _on_player_area_entered(area: Area2D) -> void:
	if current_state == State.PLAYING and area.is_in_group("bullets"):
		level_timer.stop()
		change_state(State.GAME_OVER)

func _on_level_timer_timeout() -> void:
	progress_in_Story()
	
func _process(_delta: float) -> void:
	if current_state == State.PLAYING:
		if level_timer.time_left <= bulletBlinkingSeconds and level_timer.time_left > 0.0:
			for b in get_tree().get_nodes_in_group("bullets"):
				b.start_blinking()


func _on_try_again_pressed() -> void:
	change_state(State.TITLE)
