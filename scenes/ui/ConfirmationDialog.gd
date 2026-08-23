class_name ConfirmationDialogUI
extends CanvasLayer

signal confirmed
signal cancelled

@onready var panel_container: Control = $PanelBox
@onready var message_label: Label = $PanelBox/MessageLabel
@onready var btn_yes: Button = $PanelBox/HBoxContainer/BtnYes
@onready var btn_no: Button = $PanelBox/HBoxContainer/BtnNo

func _ready() -> void:
	if panel_container:
		panel_container.visible = false
		
	var buttons: Array[Button] = [btn_yes, btn_no]
	for btn in buttons:
		if btn:
			_setup_button_hover_zoom(btn)
	
	if btn_yes and not btn_yes.pressed.is_connected(_on_yes_pressed):
		btn_yes.pressed.connect(_on_yes_pressed)
	if btn_no and not btn_no.pressed.is_connected(_on_no_pressed):
		btn_no.pressed.connect(_on_no_pressed)

func is_open() -> bool:
	return panel_container != null and panel_container.visible

func open_confirmation(message: String) -> void:
	if message_label:
		message_label.text = message
	if panel_container:
		panel_container.visible = true
	if btn_no:
		btn_no.grab_focus()

func close_confirmation() -> void:
	if panel_container:
		panel_container.visible = false

func _on_yes_pressed() -> void:
	close_confirmation()
	confirmed.emit()

func _on_no_pressed() -> void:
	close_confirmation()
	cancelled.emit()

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
	var target_scale := Vector2(1.06, 1.06) if zoom_in else Vector2(1.0, 1.0)
	tw.tween_property(btn, "scale", target_scale, 0.1)
