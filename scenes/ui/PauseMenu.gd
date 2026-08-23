class_name PauseMenuUI
extends CanvasLayer

signal pause_opened
signal pause_closed

enum PendingAction {
	NONE,
	EXPERIENCES,
	MAIN_MENU,
	EXIT_GAME
}

var _pending_action: PendingAction = PendingAction.NONE

@onready var menu_box: Control = $MenuBox
@onready var btn_resume: Button = $MenuBox/VBoxContainer/BtnResume
@onready var btn_experiences: Button = $MenuBox/VBoxContainer/BtnExperiences
@onready var btn_main_menu: Button = $MenuBox/VBoxContainer/BtnMainMenu
@onready var btn_exit_game: Button = $MenuBox/VBoxContainer/BtnExitGame
@onready var confirmation_dialog: ConfirmationDialogUI = $ConfirmationDialogUI

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	if menu_box:
		menu_box.visible = false
		
	var buttons: Array[Button] = [btn_resume, btn_experiences, btn_main_menu, btn_exit_game]
	for btn in buttons:
		if btn:
			_setup_button_hover_zoom(btn)

	if btn_resume and not btn_resume.pressed.is_connected(_on_resume_pressed):
		btn_resume.pressed.connect(_on_resume_pressed)
	if btn_experiences and not btn_experiences.pressed.is_connected(_on_experiences_pressed):
		btn_experiences.pressed.connect(_on_experiences_pressed)
	if btn_main_menu and not btn_main_menu.pressed.is_connected(_on_main_menu_pressed):
		btn_main_menu.pressed.connect(_on_main_menu_pressed)
	if btn_exit_game and not btn_exit_game.pressed.is_connected(_on_exit_game_pressed):
		btn_exit_game.pressed.connect(_on_exit_game_pressed)

	if confirmation_dialog:
		if not confirmation_dialog.confirmed.is_connected(_on_confirmation_confirmed):
			confirmation_dialog.confirmed.connect(_on_confirmation_confirmed)
		if not confirmation_dialog.cancelled.is_connected(_on_confirmation_cancelled):
			confirmation_dialog.cancelled.connect(_on_confirmation_cancelled)

func is_open() -> bool:
	return menu_box != null and menu_box.visible

func is_confirmation_open() -> bool:
	return confirmation_dialog != null and confirmation_dialog.is_open()

func open_pause_menu() -> void:
	get_tree().paused = true
	GameState.lock_player_movement()
	if menu_box:
		menu_box.visible = true
	if btn_resume:
		btn_resume.grab_focus()
	pause_opened.emit()

func close_pause_menu() -> void:
	if is_confirmation_open():
		confirmation_dialog.close_confirmation()
	_pending_action = PendingAction.NONE
	if menu_box:
		menu_box.visible = false
	get_tree().paused = false
	GameState.unlock_player_movement()
	pause_closed.emit()

func close_confirmation() -> void:
	if is_confirmation_open():
		confirmation_dialog.close_confirmation()
	_pending_action = PendingAction.NONE
	if btn_resume:
		btn_resume.grab_focus()

func _on_resume_pressed() -> void:
	close_pause_menu()

func _on_experiences_pressed() -> void:
	_pending_action = PendingAction.EXPERIENCES
	if confirmation_dialog:
		confirmation_dialog.open_confirmation("Return to Experiences?")

func _on_main_menu_pressed() -> void:
	_pending_action = PendingAction.MAIN_MENU
	if confirmation_dialog:
		confirmation_dialog.open_confirmation("Return to Main Menu?")

func _on_exit_game_pressed() -> void:
	_pending_action = PendingAction.EXIT_GAME
	if confirmation_dialog:
		confirmation_dialog.open_confirmation("Exit Game?")

func _on_confirmation_confirmed() -> void:
	var action := _pending_action
	_pending_action = PendingAction.NONE
	get_tree().paused = false
	GameState.unlock_player_movement()
	
	match action:
		PendingAction.EXPERIENCES:
			get_tree().change_scene_to_file("res://scenes/experiences/experiences.tscn")
		PendingAction.MAIN_MENU:
			get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")
		PendingAction.EXIT_GAME:
			get_tree().quit()

func _on_confirmation_cancelled() -> void:
	_pending_action = PendingAction.NONE
	if btn_resume:
		btn_resume.grab_focus()

func _setup_button_hover_zoom(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	if not btn.mouse_entered.is_connected(_on_button_hover.bind(btn, true)):
		btn.mouse_entered.connect(_on_button_hover.bind(btn, true))
	if not btn.mouse_exited.is_connected(_on_button_hover.bind(btn, false)):
		btn.mouse_exited.connect(_on_button_hover.bind(btn, false))
	if not btn.focus_entered.is_connected(_on_button_hover.bind(btn, true)):
		btn.focus_entered.connect(_on_button_hover.bind(btn, true))
	if not btn.focus_exited.is_connected(_on_button_hover.bind(btn, false)):
		btn.focus_exited.connect(_on_button_hover.bind(btn, false))

func _on_button_hover(btn: Control, zoom_in: bool) -> void:
	btn.pivot_offset = btn.size / 2.0
	var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_scale := Vector2(1.05, 1.05) if zoom_in else Vector2(1.0, 1.0)
	tw.tween_property(btn, "scale", target_scale, 0.1)
