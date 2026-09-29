extends Control

@onready var confirmation_dialog: ConfirmationDialogUI = $ConfirmationDialogUI
@onready var start_button: Button = $StartButton

# Name Input Modal Elements (Dharohar_Enter_Name_UI_Pack)
var name_modal_overlay: ColorRect = null
var name_modal_panel: Control = null
var name_frame_texture: TextureRect = null
var name_line_edit: LineEdit = null
var btn_cancel_name: TextureButton = null
var btn_confirm_name: TextureButton = null

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

	_build_name_input_modal()

func _build_name_input_modal() -> void:
	# 1. Full-screen dark backdrop overlay
	name_modal_overlay = ColorRect.new()
	name_modal_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	name_modal_overlay.color = Color(0, 0, 0, 0.75)
	name_modal_overlay.visible = false
	name_modal_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(name_modal_overlay)

	# 2. Main Modal Container (Centered, 800 x 400 px, 2:1 aspect ratio)
	name_modal_panel = Control.new()
	name_modal_panel.set_anchors_preset(Control.PRESET_CENTER)
	name_modal_panel.custom_minimum_size = Vector2(800, 400)
	name_modal_panel.offset_left = -400
	name_modal_panel.offset_top = -200
	name_modal_panel.offset_right = 400
	name_modal_panel.offset_bottom = 200
	name_modal_panel.pivot_offset = Vector2(400, 200)
	name_modal_panel.visible = false
	name_modal_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(name_modal_panel)

	# 3. Modal Background Texture (name_modal_frame.png)
	name_frame_texture = TextureRect.new()
	name_frame_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	name_frame_texture.texture = load("res://assets/Dharohar_Enter_Name_UI_Pack/name_modal_frame.png")
	name_frame_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	name_frame_texture.stretch_mode = TextureRect.STRETCH_SCALE
	name_frame_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	name_frame_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_modal_panel.add_child(name_frame_texture)

	# 4. Interactive LineEdit positioned right over the input slot
	name_line_edit = LineEdit.new()
	name_line_edit.position = Vector2(150, 172)
	name_line_edit.size = Vector2(500, 52)
	name_line_edit.placeholder_text = "Enter your name..."
	name_line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_line_edit.max_length = 24
	name_line_edit.context_menu_enabled = false
	
	var font_res = load("res://assets/Pixelify_Sans/static/PixelifySans-Bold.ttf")
	if not font_res:
		font_res = load("res://assets/Oswald/static/Oswald-Bold.ttf")
	if font_res:
		name_line_edit.add_theme_font_override("font", font_res)
	
	var empty_style := StyleBoxEmpty.new()
	empty_style.content_margin_left = 16
	empty_style.content_margin_right = 16
	empty_style.content_margin_top = 4
	empty_style.content_margin_bottom = 4
	name_line_edit.add_theme_stylebox_override("normal", empty_style)
	name_line_edit.add_theme_stylebox_override("focus", empty_style)
	name_line_edit.add_theme_color_override("font_color", Color(0.24, 0.11, 0.04, 1.0))
	name_line_edit.add_theme_color_override("font_selected_color", Color(0.12, 0.05, 0.01, 1.0))
	name_line_edit.add_theme_color_override("selection_color", Color(0.85, 0.65, 0.35, 0.5))
	name_line_edit.add_theme_color_override("caret_color", Color(0.24, 0.11, 0.04, 1.0))
	name_line_edit.add_theme_color_override("font_placeholder_color", Color(0.55, 0.45, 0.35, 0.75))
	name_line_edit.add_theme_font_size_override("font_size", 24)
	name_line_edit.text_submitted.connect(func(_t: String): _on_confirm_name_pressed())
	name_modal_panel.add_child(name_line_edit)

	# 5. Back Button (TextureButton)
	btn_cancel_name = TextureButton.new()
	btn_cancel_name.position = Vector2(106, 239)
	btn_cancel_name.size = Vector2(268, 68)
	btn_cancel_name.texture_normal = load("res://assets/Dharohar_Enter_Name_UI_Pack/back_button.png")
	btn_cancel_name.texture_hover = load("res://assets/Dharohar_Enter_Name_UI_Pack/back_button_hover.png")
	btn_cancel_name.texture_pressed = load("res://assets/Dharohar_Enter_Name_UI_Pack/back_button_pressed.png")
	btn_cancel_name.ignore_texture_size = true
	btn_cancel_name.stretch_mode = TextureButton.STRETCH_SCALE
	btn_cancel_name.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	btn_cancel_name.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn_cancel_name.pressed.connect(_close_name_modal)
	_setup_tex_btn_hover(btn_cancel_name)
	name_modal_panel.add_child(btn_cancel_name)

	# 6. Begin Journey Button (TextureButton)
	btn_confirm_name = TextureButton.new()
	btn_confirm_name.position = Vector2(398, 239)
	btn_confirm_name.size = Vector2(284, 68)
	btn_confirm_name.texture_normal = load("res://assets/Dharohar_Enter_Name_UI_Pack/begin_journey_button.png")
	btn_confirm_name.texture_hover = load("res://assets/Dharohar_Enter_Name_UI_Pack/begin_journey_button_hover.png")
	btn_confirm_name.texture_pressed = load("res://assets/Dharohar_Enter_Name_UI_Pack/begin_journey_button_pressed.png")
	btn_confirm_name.ignore_texture_size = true
	btn_confirm_name.stretch_mode = TextureButton.STRETCH_SCALE
	btn_confirm_name.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	btn_confirm_name.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn_confirm_name.pressed.connect(_on_confirm_name_pressed)
	_setup_tex_btn_hover(btn_confirm_name)
	name_modal_panel.add_child(btn_confirm_name)

func _setup_tex_btn_hover(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(btn, "scale", Vector2(1.03, 1.03), 0.1)
	)
	btn.mouse_exited.connect(func():
		var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)

func _unhandled_input(event: InputEvent) -> void:
	if name_modal_panel and name_modal_panel.visible:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("escape"):
			get_viewport().set_input_as_handled()
			_close_name_modal()
			return

	if event.is_action_pressed("escape") or event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		if confirmation_dialog:
			if confirmation_dialog.is_open():
				confirmation_dialog.close_confirmation()
			else:
				confirmation_dialog.open_confirmation("Exit Game?")

func _on_start_button_pressed() -> void:
	_open_name_modal()

func _open_name_modal() -> void:
	if name_modal_overlay:
		name_modal_overlay.visible = true
	if name_modal_panel:
		name_modal_panel.visible = true
		name_modal_panel.scale = Vector2(0.9, 0.9)
		name_modal_panel.modulate.a = 0.0
		var tw := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel(true)
		tw.tween_property(name_modal_panel, "scale", Vector2(1.0, 1.0), 0.22)
		tw.tween_property(name_modal_panel, "modulate:a", 1.0, 0.18)
		
	if name_line_edit:
		name_line_edit.text = "Player"
		name_line_edit.grab_focus()
		name_line_edit.select_all()

func _close_name_modal() -> void:
	if name_modal_overlay:
		name_modal_overlay.visible = false
	if name_modal_panel:
		name_modal_panel.visible = false
	if start_button:
		start_button.grab_focus()

func _on_confirm_name_pressed() -> void:
	var entered_name := ""
	if name_line_edit:
		entered_name = name_line_edit.text.strip_edges()
	
	if entered_name == "":
		entered_name = "Player"
		
	if GameState:
		GameState.reset_for_new_game()
		GameState.set_player_name(entered_name)
		
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
