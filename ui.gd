extends CanvasLayer

# Eigene Signale, die an main.gd gemeldet werden:
signal start_pressed
signal next_dialog_pressed
signal try_again_pressed

@onready var title_screen: Control = $TitleScreen
@onready var dialog_box: Control = $DialogBox
@onready var dialog_label: Label = $DialogBox/Dialog
@onready var game_over_screen: Control = $GameOverScreen
@onready var game_end_screen: Control = $GameEndScreen

func hide_all() -> void:
	title_screen.hide()
	dialog_box.hide()
	game_over_screen.hide()
	game_end_screen.hide()

func show_title() -> void:
	hide_all()
	title_screen.show()

func show_dialog(level: int) -> void:
	hide_all()
	match level:
		1:
			dialog_label.text = "Welcome to this Game, this is a initial Dialog,\n  klick 'next' for starting the game"
		2:
			dialog_label.text = "HA! You lost this level.. or maybe won...\n at least you've been hit by the bullet!"
		3:
			dialog_label.text = "How do you like that?\n This is your last chance!!\n Good luck!"
	dialog_box.show()

func show_game_over() -> void:
	hide_all()
	game_over_screen.show()

func show_game_end() -> void:
	hide_all()
	game_end_screen.show()

# --- BUTTON-SIGNALE (in ui.gd verknüpft!) ---
func _on_start_button_pressed() -> void:
	start_pressed.emit()

func _on_try_again_pressed() -> void:
	try_again_pressed.emit()

func _on_next_button_pressed() -> void:
	next_dialog_pressed.emit()
