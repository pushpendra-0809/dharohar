extends Control

@onready var back_button: Button = $back
@onready var nalanda_button: Button = $Nalanda_Button
@onready var comingsoon_button1: Button = $comingsoon_button1
@onready var comingsoon_button2: Button = $comingsoon_button2

const HAMPI_TEX = preload("res://assets/hampi/hampi button.png")
const COMING_SOON_TEX = preload("res://assets/ui/coming sooon.png")

func _ready() -> void:
	var buttons: Array[Button] = [back_button, nalanda_button, comingsoon_button1, comingsoon_button2]
	for btn in buttons:
		if btn:
			_setup_button_hover_zoom(btn)
			
	if comingsoon_button1:
		comingsoon_button1.pressed.connect(_on_comingsoon1_pressed)
	if comingsoon_button2:
		comingsoon_button2.pressed.connect(_on_comingsoon2_pressed)
		
	_check_dev_mode_ui()

func _check_dev_mode_ui() -> void:
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	
	if is_dev:
		_set_button_texture(comingsoon_button1, HAMPI_TEX)
		if comingsoon_button1:
			comingsoon_button1.offset_left = 258.0
			comingsoon_button1.offset_top = 208.0
			comingsoon_button1.offset_right = 439.0
			comingsoon_button1.offset_bottom = 462.0
	else:
		_set_button_texture(comingsoon_button1, COMING_SOON_TEX)
		if comingsoon_button1:
			comingsoon_button1.offset_left = 261.0
			comingsoon_button1.offset_top = 212.0
			comingsoon_button1.offset_right = 436.0
			comingsoon_button1.offset_bottom = 448.0

func _set_button_texture(btn: Button, tex: Texture2D) -> void:
	if not btn or not tex:
		return
		
	var norm := StyleBoxTexture.new()
	norm.texture = tex
	
	var press := StyleBoxTexture.new()
	press.texture = tex
	
	var hov := StyleBoxTexture.new()
	hov.texture = tex
	hov.expand_margin_left = 4.0
	hov.expand_margin_top = 4.0
	hov.expand_margin_right = 4.0
	hov.expand_margin_bottom = 4.0
	
	btn.add_theme_stylebox_override("normal", norm)
	btn.add_theme_stylebox_override("pressed", press)
	btn.add_theme_stylebox_override("hover", hov)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("back"):
		get_viewport().set_input_as_handled()
		_on_back_pressed()

func _on_nalanda_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nalanda.tscn")

func _on_comingsoon1_pressed() -> void:
	var dev = get_node_or_null("/root/DevModeManager")
	if dev and dev.dev_mode_enabled:
		get_tree().change_scene_to_file("res://scenes/nalanda_university.tscn")

func _on_comingsoon2_pressed() -> void:
	var dev = get_node_or_null("/root/DevModeManager")
	if dev and dev.dev_mode_enabled:
		get_tree().change_scene_to_file("res://scenes/nalanda.tscn")

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
