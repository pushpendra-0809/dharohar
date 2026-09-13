extends Control

@onready var back_button: Button = $back
@onready var nalanda_button: Button = $Nalanda_Button
@onready var comingsoon_button1: Button = $comingsoon_button1
@onready var comingsoon_button2: Button = $comingsoon_button2

@onready var nalanda_badge: Label = get_node_or_null("NalandaBadge")
@onready var hampi_badge: Label = get_node_or_null("HampiBadge")
@onready var toast_panel: Panel = get_node_or_null("ToastPanel")
@onready var toast_label: Label = get_node_or_null("ToastPanel/ToastLabel")
@onready var toast_timer: Timer = get_node_or_null("ToastTimer")

const HAMPI_TEX = preload("res://assets/hampi/hampi button.png")
const COMING_SOON_TEX = preload("res://assets/ui/coming sooon.png")
const CutscenePlayer = preload("res://scripts/systems/CutscenePlayer.gd")

var _toast_tween: Tween = null

func _ready() -> void:
	var buttons: Array[Button] = [back_button, nalanda_button, comingsoon_button1, comingsoon_button2]
	for btn in buttons:
		if btn:
			_setup_button_hover_zoom(btn)
			
	if nalanda_button and not nalanda_button.pressed.is_connected(_on_nalanda_button_pressed):
		nalanda_button.pressed.connect(_on_nalanda_button_pressed)
	if back_button and not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)
	if comingsoon_button1 and not comingsoon_button1.pressed.is_connected(_on_comingsoon1_pressed):
		comingsoon_button1.pressed.connect(_on_comingsoon1_pressed)
	if comingsoon_button2 and not comingsoon_button2.pressed.is_connected(_on_comingsoon2_pressed):
		comingsoon_button2.pressed.connect(_on_comingsoon2_pressed)
		
	if toast_timer and not toast_timer.timeout.is_connected(_on_toast_timeout):
		toast_timer.timeout.connect(_on_toast_timeout)
		
	if toast_panel:
		toast_panel.modulate.a = 0.0
		toast_panel.visible = false
		
	_refresh_experience_hub_state()

func _refresh_experience_hub_state() -> void:
	var is_nalanda_done: bool = GameState != null and GameState.nalanda_complete
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	var is_hampi_unlocked: bool = is_nalanda_done or is_dev
	
	# 1. Nalanda Card State
	if nalanda_badge:
		if is_nalanda_done:
			nalanda_badge.text = "✓ COMPLETE"
			nalanda_badge.modulate = Color(0.4, 1.0, 0.4, 1.0)
			nalanda_badge.visible = true
		else:
			nalanda_badge.visible = false
			
	# 2. Experience 2 / Hampi Card State
	if is_hampi_unlocked:
		_set_button_texture(comingsoon_button1, HAMPI_TEX)
		if comingsoon_button1:
			comingsoon_button1.offset_left = 258.0
			comingsoon_button1.offset_top = 208.0
			comingsoon_button1.offset_right = 439.0
			comingsoon_button1.offset_bottom = 462.0
		if hampi_badge:
			hampi_badge.text = "🔓 UNLOCKED"
			hampi_badge.modulate = Color(1.0, 0.85, 0.3, 1.0)
			hampi_badge.visible = true
	else:
		_set_button_texture(comingsoon_button1, COMING_SOON_TEX)
		if comingsoon_button1:
			comingsoon_button1.offset_left = 261.0
			comingsoon_button1.offset_top = 212.0
			comingsoon_button1.offset_right = 436.0
			comingsoon_button1.offset_bottom = 448.0
		if hampi_badge:
			hampi_badge.text = "🔒 LOCKED"
			hampi_badge.modulate = Color(0.7, 0.7, 0.7, 0.8)
			hampi_badge.visible = true

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
	if GameState and not GameState.has_played_nalanda_intro_cutscene:
		GameState.has_played_nalanda_intro_cutscene = true
		CutscenePlayer.play_video(self, "res://assets/videos/video1.ogv", _transition_to_nalanda)
	else:
		_transition_to_nalanda()

func _transition_to_nalanda() -> void:
	if ResourceLoader.exists("res://scenes/nalanda/nalanda.tscn"):
		get_tree().change_scene_to_file("res://scenes/nalanda/nalanda.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/nalanda.tscn")

func _on_comingsoon1_pressed() -> void:
	var is_nalanda_done: bool = GameState != null and GameState.nalanda_complete
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	
	if is_nalanda_done or is_dev:
		# Check if Hampi scene exists
		if ResourceLoader.exists("res://scenes/hampi.tscn"):
			get_tree().change_scene_to_file("res://scenes/hampi.tscn")
		elif ResourceLoader.exists("res://scenes/hampi/hampi.tscn"):
			get_tree().change_scene_to_file("res://scenes/hampi/hampi.tscn")
		else:
			# Unlocked state feedback (Hampi gameplay content releasing in Step 21 / upcoming expansion)
			_show_toast("Hampi: The City of Victory — Unlocked!\n(Heritage chapter launching in next content release)")
	else:
		_show_toast("Complete the Nalanda experience to unlock this heritage journey.")

func _on_comingsoon2_pressed() -> void:
	_show_toast("Experience 3: Coming Soon in future updates.")

func _show_toast(message: String) -> void:
	if not toast_panel or not toast_label:
		return
		
	toast_label.text = message
	toast_panel.visible = true
	
	if _toast_tween:
		_toast_tween.kill()
		
	_toast_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_toast_tween.tween_property(toast_panel, "modulate:a", 1.0, 0.2)
	
	if toast_timer:
		toast_timer.start(2.8)

func _on_toast_timeout() -> void:
	if not toast_panel:
		return
	if _toast_tween:
		_toast_tween.kill()
	_toast_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_toast_tween.tween_property(toast_panel, "modulate:a", 0.0, 0.3)
	_toast_tween.tween_callback(func():
		if toast_panel:
			toast_panel.visible = false
	)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _setup_button_hover_zoom(btn: Button) -> void:
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
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
