extends Control

@onready var confirmation_dialog: ConfirmationDialogUI = $ConfirmationDialogUI
@onready var start_button: Button = $StartButton

func _ready() -> void:
	if confirmation_dialog:
		if not confirmation_dialog.confirmed.is_connected(_on_exit_confirmed):
			confirmation_dialog.confirmed.connect(_on_exit_confirmed)
		if not confirmation_dialog.cancelled.is_connected(_on_exit_cancelled):
			confirmation_dialog.cancelled.connect(_on_exit_cancelled)
			
	if start_button:
		start_button.pivot_offset = start_button.size / 2.0
		if not start_button.mouse_entered.is_connected(_on_button_hover.bind(start_button, true)):
			start_button.mouse_entered.connect(_on_button_hover.bind(start_button, true))
		if not start_button.mouse_exited.is_connected(_on_button_hover.bind(start_button, false)):
			start_button.mouse_exited.connect(_on_button_hover.bind(start_button, false))
		if not start_button.focus_entered.is_connected(_on_button_hover.bind(start_button, true)):
			start_button.focus_entered.connect(_on_button_hover.bind(start_button, true))
		if not start_button.focus_exited.is_connected(_on_button_hover.bind(start_button, false)):
			start_button.focus_exited.connect(_on_button_hover.bind(start_button, false))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") or event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		if confirmation_dialog:
			if confirmation_dialog.is_open():
				confirmation_dialog.close_confirmation()
			else:
				confirmation_dialog.open_confirmation("Exit Game?")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/experiences/experiences.tscn")

func _on_exit_confirmed() -> void:
	get_tree().quit()

func _on_exit_cancelled() -> void:
	if start_button:
		start_button.release_focus()

func _on_button_hover(btn: Control, zoom_in: bool) -> void:
	btn.pivot_offset = btn.size / 2.0
	var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_scale := Vector2(1.06, 1.06) if zoom_in else Vector2(1.0, 1.0)
	tw.tween_property(btn, "scale", target_scale, 0.12)
