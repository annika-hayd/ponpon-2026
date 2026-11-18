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
@onready var start_button: Button = $TitleScreen/StartButton
@onready var next_button: Button = $DialogBox/NextButton
@onready var try_again_button: Button = $GameOverScreen/TryAgain
@onready var game_end_button: Button = $GameEndScreen/TryAgain

func hide_all() -> void:
	title_screen.hide()
	dialog_box.hide()
	game_over_screen.hide()
	game_end_screen.hide()

func show_title() -> void:
	hide_all()
	title_screen.show()
	start_button.grab_focus()

func show_dialog(level: int) -> void:
	hide_all()
	match level:
		1:
			dialog_label.text = tr("DIALOG_1_CLAW_1")
		2:
			dialog_label.text = tr("DIALOG_2_CLAW_1")
		3:
			dialog_label.text = tr("DIALOG_3_CLAW_1")
	dialog_box.show()
	next_button.grab_focus()

func show_game_over() -> void:
	hide_all()
	game_over_screen.show()
	try_again_button.grab_focus()

func show_game_end() -> void:
	hide_all()
	game_end_screen.show()
	game_end_button.grab_focus()

# --- BUTTON-SIGNALE (in ui.gd verknüpft!) ---
func _on_start_button_pressed() -> void:
	start_pressed.emit()

func _on_try_again_pressed() -> void:
	try_again_pressed.emit()

func _on_next_button_pressed() -> void:
	next_dialog_pressed.emit()
