extends Control

@onready var back_button: Button = $back
@onready var nalanda_button: Button = $Nalanda_Button

func _ready() -> void:
	var buttons: Array[Button] = [back_button, nalanda_button]
	for btn in buttons:
		if btn:
			_setup_button_hover_zoom(btn)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("back"):
		get_viewport().set_input_as_handled()
		_on_back_pressed()

func _on_nalanda_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nalanda/nalanda.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

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
	tw.tween_property(btn, "scale", target_scale, 0.12)
