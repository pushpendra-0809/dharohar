extends CanvasLayer

# ==============================================================================
# DHAROHAR 1.0 — DEVELOPER MODE & DOMAIN TESTING MANAGER (AUTOLOAD)
# ==============================================================================
# Press [TAB] anytime in-game to toggle the Dev Jump & Domain Testing Menu.
# Switch between Mathematics, Astronomy, Medicine, and Philosophy seamlessly.

const DEV_MODE_AVAILABLE: bool = true
const TARGET_SEQUENCE: String = "278007"
const DEV_TIMEOUT: float = 3.0

var dev_mode_enabled: bool = false
var _current_sequence: String = ""
var _last_press_time: float = 0.0

# UI State
var is_menu_open: bool = false
var active_domain_name: String = "mathematics"

# UI Elements
var overlay_rect: ColorRect
var main_panel: PanelContainer
var watermark_label: Label
var toast_banner: PanelContainer
var toast_label: Label
var domain_indicator_label: Label

# Views
var view_domain_matrix: VBoxContainer
var view_progression: VBoxContainer
var view_landmarks: VBoxContainer
var view_teleports: VBoxContainer
var view_cheats: VBoxContainer
var tab_buttons: Array = []
var view_containers: Array = []
var domain_bar_buttons: Dictionary = {}

func _ready() -> void:
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if not DEV_MODE_AVAILABLE:
		return
		
	_sync_active_domain()
	_build_ui()

func _input(event: InputEvent) -> void:
	if not DEV_MODE_AVAILABLE:
		return
		
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		# 1. TAB key toggles Dev Menu ONLY IF Dev Mode is already active (via passcode 278007)
		if event.keycode == KEY_TAB:
			if dev_mode_enabled:
				get_viewport().set_input_as_handled()
				toggle_dev_menu()
			return
			
		# 2. ESCAPE closes Dev Menu if open
		if is_menu_open and (event.keycode == KEY_ESCAPE or event.is_action_pressed("ui_cancel")):
			get_viewport().set_input_as_handled()
			close_dev_menu()
			return
			
		# 3. Secret passcode sequence '278007'
		var digit := _get_digit_from_event(event)
		if digit != "":
			var current_time := Time.get_ticks_msec() / 1000.0
			if _current_sequence == "" or (current_time - _last_press_time <= DEV_TIMEOUT):
				_current_sequence += digit
				_last_press_time = current_time
				if _current_sequence.ends_with(TARGET_SEQUENCE):
					_current_sequence = ""
					if dev_mode_enabled:
						_disable_dev_mode_and_restart()
					else:
						_enable_dev_mode()
			else:
				_current_sequence = digit
				_last_press_time = current_time

func _get_digit_from_event(event: InputEventKey) -> String:
	match event.keycode:
		KEY_0, KEY_KP_0: return "0"
		KEY_1, KEY_KP_1: return "1"
		KEY_2, KEY_KP_2: return "2"
		KEY_3, KEY_KP_3: return "3"
		KEY_4, KEY_KP_4: return "4"
		KEY_5, KEY_KP_5: return "5"
		KEY_6, KEY_KP_6: return "6"
		KEY_7, KEY_KP_7: return "7"
		KEY_8, KEY_KP_8: return "8"
		KEY_9, KEY_KP_9: return "9"
	match event.physical_keycode:
		KEY_0, KEY_KP_0: return "0"
		KEY_1, KEY_KP_1: return "1"
		KEY_2, KEY_KP_2: return "2"
		KEY_3, KEY_KP_3: return "3"
		KEY_4, KEY_KP_4: return "4"
		KEY_5, KEY_KP_5: return "5"
		KEY_6, KEY_KP_6: return "6"
		KEY_7, KEY_KP_7: return "7"
		KEY_8, KEY_KP_8: return "8"
		KEY_9, KEY_KP_9: return "9"
	match event.key_label:
		KEY_0, KEY_KP_0: return "0"
		KEY_1, KEY_KP_1: return "1"
		KEY_2, KEY_KP_2: return "2"
		KEY_3, KEY_KP_3: return "3"
		KEY_4, KEY_KP_4: return "4"
		KEY_5, KEY_KP_5: return "5"
		KEY_6, KEY_KP_6: return "6"
		KEY_7, KEY_KP_7: return "7"
		KEY_8, KEY_KP_8: return "8"
		KEY_9, KEY_KP_9: return "9"
	if event.unicode >= 48 and event.unicode <= 57:
		return String.chr(event.unicode)
	return ""

func _sync_active_domain() -> void:
	var gs = _get_game_state()
	if gs and gs.selected_domain != "":
		active_domain_name = gs.selected_domain.to_lower().strip_edges()
	else:
		active_domain_name = "mathematics"

# ==============================================================================
# UI CONSTRUCTION
# ==============================================================================
func _build_ui() -> void:
	# 1. Watermark Label
	watermark_label = Label.new()
	watermark_label.text = "✦ DEV MODE ACTIVE [TAB FOR MENU] ✦"
	watermark_label.modulate = Color(1.0, 0.85, 0.4, 0.75)
	watermark_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	watermark_label.position = Vector2(16, 12)
	watermark_label.visible = false
	watermark_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(watermark_label)
	
	# 2. Toast Notification Banner
	_build_toast_banner()
	
	# 3. Fullscreen Overlay & Dev Jump Menu
	_build_dev_menu_modal()

func _build_toast_banner() -> void:
	toast_banner = PanelContainer.new()
	toast_banner.set_anchors_preset(Control.PRESET_CENTER_TOP)
	toast_banner.offset_left = -300
	toast_banner.offset_top = 16
	toast_banner.offset_right = 300
	toast_banner.offset_bottom = 56
	toast_banner.visible = false
	toast_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.08, 0.05, 0.95)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(1.0, 0.85, 0.45, 1.0)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	style.content_margin_left = 16
	style.content_margin_top = 6
	style.content_margin_right = 16
	style.content_margin_bottom = 6
	toast_banner.add_theme_stylebox_override("panel", style)
	
	toast_label = Label.new()
	toast_label.text = "✦ DEV JUMP ACTIVATED ✦"
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5, 1.0))
	toast_label.add_theme_font_size_override("font_size", 13)
	toast_banner.add_child(toast_label)
	
	add_child(toast_banner)

func _build_dev_menu_modal() -> void:
	# Semi-transparent dark overlay
	overlay_rect = ColorRect.new()
	overlay_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_rect.color = Color(0, 0, 0, 0.75)
	overlay_rect.visible = false
	add_child(overlay_rect)
	
	# Main Dialog Panel
	main_panel = PanelContainer.new()
	main_panel.set_anchors_preset(Control.PRESET_CENTER)
	main_panel.offset_left = -440
	main_panel.offset_top = -290
	main_panel.offset_right = 440
	main_panel.offset_bottom = 290
	main_panel.visible = false
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.11, 0.08, 0.06, 0.98)
	panel_style.border_width_left = 3
	panel_style.border_width_top = 3
	panel_style.border_width_right = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = Color(0.9, 0.75, 0.35, 1.0)
	panel_style.corner_radius_top_left = 10
	panel_style.corner_radius_top_right = 10
	panel_style.corner_radius_bottom_right = 10
	panel_style.corner_radius_bottom_left = 10
	panel_style.shadow_size = 16
	panel_style.shadow_color = Color(0, 0, 0, 0.8)
	panel_style.content_margin_left = 18
	panel_style.content_margin_top = 12
	panel_style.content_margin_right = 18
	panel_style.content_margin_bottom = 12
	main_panel.add_theme_stylebox_override("panel", panel_style)
	
	var root_vbox := VBoxContainer.new()
	root_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_vbox.add_theme_constant_override("separation", 8)
	main_panel.add_child(root_vbox)
	
	# --- 1. HEADER ---
	var header_hbox := HBoxContainer.new()
	
	var title_vbox := VBoxContainer.new()
	title_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var title_lbl := Label.new()
	title_lbl.text = "✦ DHAROHAR 1.0 — DEVELOPER JUMP & DOMAIN TESTER ✦"
	title_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.35, 1.0))
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_vbox.add_child(title_lbl)
	
	var sub_lbl := Label.new()
	sub_lbl.text = "Press [TAB] or [ESC] to toggle | Switch active domain below or jump to any stage/trial immediately"
	sub_lbl.add_theme_color_override("font_color", Color(0.85, 0.8, 0.7, 1.0))
	sub_lbl.add_theme_font_size_override("font_size", 11)
	title_vbox.add_child(sub_lbl)
	
	header_hbox.add_child(title_vbox)
	
	var close_btn := Button.new()
	close_btn.text = " ✕ "
	close_btn.custom_minimum_size = Vector2(30, 30)
	close_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_btn.pressed.connect(close_dev_menu)
	header_hbox.add_child(close_btn)
	
	root_vbox.add_child(header_hbox)
	
	# --- 2. ACTIVE DOMAIN SELECTOR BAR ---
	var domain_bar := PanelContainer.new()
	var d_style := StyleBoxFlat.new()
	d_style.bg_color = Color(0.16, 0.11, 0.08, 0.95)
	d_style.border_width_left = 1
	d_style.border_width_top = 1
	d_style.border_width_right = 1
	d_style.border_width_bottom = 1
	d_style.border_color = Color(0.7, 0.55, 0.3, 0.8)
	d_style.corner_radius_top_left = 6
	d_style.corner_radius_top_right = 6
	d_style.corner_radius_bottom_right = 6
	d_style.corner_radius_bottom_left = 6
	d_style.content_margin_left = 8
	d_style.content_margin_top = 4
	d_style.content_margin_right = 8
	d_style.content_margin_bottom = 4
	domain_bar.add_theme_stylebox_override("panel", d_style)
	
	var d_hbox := HBoxContainer.new()
	d_hbox.add_theme_constant_override("separation", 6)
	
	domain_indicator_label = Label.new()
	domain_indicator_label.text = "TEST DOMAIN: "
	domain_indicator_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.4, 1.0))
	domain_indicator_label.add_theme_font_size_override("font_size", 12)
	d_hbox.add_child(domain_indicator_label)
	
	var doms := [
		{"name": "📐 MATHEMATICS", "id": "mathematics"},
		{"name": "⭐ ASTRONOMY", "id": "astronomy"},
		{"name": "🌿 MEDICINE", "id": "medicine"},
		{"name": "📜 PHILOSOPHY", "id": "philosophy"}
	]
	
	for d in doms:
		var d_id: String = d["id"]
		var btn := Button.new()
		btn.text = d["name"]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 28)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.pressed.connect(_set_active_domain.bind(d_id))
		d_hbox.add_child(btn)
		domain_bar_buttons[d_id] = btn
		
	domain_bar.add_child(d_hbox)
	root_vbox.add_child(domain_bar)
	
	# --- 3. CATEGORY TABS BAR ---
	var tabs_hbox := HBoxContainer.new()
	tabs_hbox.add_theme_constant_override("separation", 6)
	
	var tab_names := ["🎓 DOMAIN TRIAL SUITES", "📌 PROGRESSION STEPS", "🏛️ ALL LANDMARKS", "🗺️ TELEPORTS", "⚡ CHEATS"]
	for i in range(tab_names.size()):
		var t_btn := Button.new()
		t_btn.text = tab_names[i]
		t_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		t_btn.custom_minimum_size = Vector2(0, 30)
		t_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		t_btn.pressed.connect(_switch_tab.bind(i))
		tabs_hbox.add_child(t_btn)
		tab_buttons.append(t_btn)
		
	root_vbox.add_child(tabs_hbox)
	
	# --- 4. SCROLL CONTAINER FOR CATEGORY VIEWS ---
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	
	var content_margin := MarginContainer.new()
	content_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_margin.add_theme_constant_override("margin_top", 4)
	content_margin.add_theme_constant_override("margin_bottom", 4)
	
	var views_stack := Control.new()
	views_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_margin.add_child(views_stack)
	scroll.add_child(content_margin)
	root_vbox.add_child(scroll)
	
	# Build the 5 Category Views
	view_domain_matrix = _build_domain_matrix_view()
	view_progression = _build_progression_view()
	view_landmarks = _build_landmarks_view()
	view_teleports = _build_teleports_view()
	view_cheats = _build_cheats_view()
	
	view_containers = [view_domain_matrix, view_progression, view_landmarks, view_teleports, view_cheats]
	for v in view_containers:
		views_stack.add_child(v)
		
	_update_domain_bar_highlight()
	_switch_tab(0)
	add_child(main_panel)

func _switch_tab(idx: int) -> void:
	for i in range(view_containers.size()):
		var is_active := (i == idx)
		view_containers[i].visible = is_active
		if i < tab_buttons.size():
			var btn: Button = tab_buttons[i]
			if is_active:
				btn.modulate = Color(1.0, 0.9, 0.4, 1.0)
			else:
				btn.modulate = Color(0.7, 0.7, 0.7, 0.85)

func _set_active_domain(domain_id: String) -> void:
	active_domain_name = domain_id.to_lower().strip_edges()
	var gs = _get_game_state()
	if gs:
		gs.selected_domain = active_domain_name
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_update_domain_bar_highlight()
	_show_toast("Active Domain set to: " + active_domain_name.to_upper())

func _update_domain_bar_highlight() -> void:
	for d_id in domain_bar_buttons:
		var btn: Button = domain_bar_buttons[d_id]
		if d_id == active_domain_name:
			btn.modulate = Color(1.0, 0.9, 0.35, 1.0)
			btn.text = "✓ " + d_id.to_upper()
		else:
			btn.modulate = Color(0.75, 0.75, 0.75, 0.8)
			btn.text = d_id.to_upper()

# ==============================================================================
# VIEW 0: DEDICATED DOMAIN TRIAL SUITES
# ==============================================================================
func _build_domain_matrix_view() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	vbox.add_theme_constant_override("separation", 6)
	
	_add_section_header(vbox, "TEST ANY LEARNING DOMAIN ACROSS ALL CHALLENGES")
	
	var domains_data := [
		{
			"id": "mathematics",
			"title": "📐 MATHEMATICS (GAṆITA)",
			"subtitle": "Decimal place value, Zero, Arithmetic progressions, Geometry",
			"stupa_desc": "Stupa: Piano-Tiles Number Stream Calculation Challenge",
			"lib_desc": "Library: Aryabhatiya Folio Search & Circumference Reconstruction"
		},
		{
			"id": "astronomy",
			"title": "⭐ ASTRONOMY (JYOTIṢA)",
			"subtitle": "27 Nakshatras, Gnomon shadow timekeeping, Planetary orbits",
			"stupa_desc": "Stupa: Constellation Pattern Alignment & Star Coordination",
			"lib_desc": "Library: Ghati-Chhaya Gnomon Timekeeping Folio & Meridian Clues"
		},
		{
			"id": "medicine",
			"title": "🌿 MEDICINE (ĀYURVEDA)",
			"subtitle": "Tridosha balance, Botanical pharmacopoeia, Triphala preparations",
			"stupa_desc": "Stupa: Herbal Botanical Mahjong Matching Trial",
			"lib_desc": "Library: Triphala Kalpana Botanical Formulation Folio"
		},
		{
			"id": "philosophy",
			"title": "📜 PHILOSOPHY (NYĀYA / VĀDA)",
			"subtitle": "5-limbed syllogism (Pañcāvayava), Epistemic pramana, Vyapti logic",
			"stupa_desc": "Stupa: 5-Step Logic Syllogism Construction Trial",
			"lib_desc": "Library: Nyaya Sutra Varttika Dialectic Folio"
		}
	]
	
	for d in domains_data:
		var d_id: String = d["id"]
		
		var card := PanelContainer.new()
		var cs := StyleBoxFlat.new()
		cs.bg_color = Color(0.17, 0.12, 0.08, 0.95)
		cs.border_width_left = 2
		cs.border_width_top = 1
		cs.border_width_right = 1
		cs.border_width_bottom = 2
		cs.border_color = Color(0.75, 0.6, 0.3, 0.9)
		cs.corner_radius_top_left = 6
		cs.corner_radius_top_right = 6
		cs.corner_radius_bottom_right = 6
		cs.corner_radius_bottom_left = 6
		cs.content_margin_left = 10
		cs.content_margin_top = 6
		cs.content_margin_right = 10
		cs.content_margin_bottom = 6
		card.add_theme_stylebox_override("panel", cs)
		
		var c_vbox := VBoxContainer.new()
		c_vbox.add_theme_constant_override("separation", 4)
		
		var h_box := HBoxContainer.new()
		var t_lbl := Label.new()
		t_lbl.text = d["title"]
		t_lbl.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4, 1.0))
		t_lbl.add_theme_font_size_override("font_size", 13)
		t_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h_box.add_child(t_lbl)
		
		var activate_btn := Button.new()
		activate_btn.text = "SET ACTIVE DOMAIN"
		activate_btn.custom_minimum_size = Vector2(130, 24)
		activate_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		activate_btn.pressed.connect(_set_active_domain.bind(d_id))
		h_box.add_child(activate_btn)
		c_vbox.add_child(h_box)
		
		var sub_lbl := Label.new()
		sub_lbl.text = d["subtitle"]
		sub_lbl.add_theme_color_override("font_color", Color(0.8, 0.75, 0.65, 1.0))
		sub_lbl.add_theme_font_size_override("font_size", 10)
		c_vbox.add_child(sub_lbl)
		
		# Quick Action Buttons row for this domain
		var actions_hbox := HBoxContainer.new()
		actions_hbox.add_theme_constant_override("separation", 6)
		
		var btn_stupa := Button.new()
		btn_stupa.text = "🏛️ Stupa Trial"
		btn_stupa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_stupa.custom_minimum_size = Vector2(0, 26)
		btn_stupa.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn_stupa.pressed.connect(func():
			_set_active_domain(d_id)
			_launch_stupa_challenge()
		)
		actions_hbox.add_child(btn_stupa)
		
		var btn_lib := Button.new()
		btn_lib.text = "📚 Library Trial"
		btn_lib.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_lib.custom_minimum_size = Vector2(0, 26)
		btn_lib.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn_lib.pressed.connect(func():
			_set_active_domain(d_id)
			_launch_library_challenge()
		)
		actions_hbox.add_child(btn_lib)
		
		var btn_vihara := Button.new()
		btn_vihara.text = "🏡 Vihara Trial"
		btn_vihara.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_vihara.custom_minimum_size = Vector2(0, 26)
		btn_vihara.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn_vihara.pressed.connect(func():
			_set_active_domain(d_id)
			_launch_vihara_challenge()
		)
		actions_hbox.add_child(btn_vihara)
		
		c_vbox.add_child(actions_hbox)
		card.add_child(c_vbox)
		vbox.add_child(card)
		
	return vbox

# ==============================================================================
# VIEW 1: PROGRESSION STEPS
# ==============================================================================
func _build_progression_view() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	vbox.add_theme_constant_override("separation", 5)
	
	_add_section_header(vbox, "NALANDA STORY PROGRESSION CHECKPOINTS")
	
	_add_action_button(vbox, "1. 🎮 Fresh Game Start (Prologue / Main Menu)", "Resets all progression to start and opens Main Menu.", func():
		_jump_fresh_start()
	)
	
	_add_action_button(vbox, "2. 🎓 Teacher 1 (Admission & Domain Selection)", "Teleports to Teacher 1 ready for learning & domain trial.", func():
		_jump_teacher1()
	)
	
	_add_action_button(vbox, "3. 🚪 Teacher 2 / Gatekeeper (Practice & Entry)", "Domain chosen, water quest complete. Ready at Gatekeeper.", func():
		_jump_teacher2()
	)
	
	_add_action_button(vbox, "4. 📜 Teacher 3 (Mastery Mentor & Landmark Intro)", "Admitted to campus, met Teacher 3. Ready for NPC side tasks.", func():
		_jump_teacher3()
	)
	
	_add_action_button(vbox, "5. 🏛️ Gate 1: Stupa Unlocked (1 NPC Task / 50 EXP)", "Completed 1 NPC side quest (50 EXP). Stupa concentration trial unlocked.", func():
		_jump_stupa_unlocked()
	)
	
	_add_action_button(vbox, "6. 📚 Gate 2: Library Unlocked (Stupa Complete + 3 NPC Tasks / 150 EXP)", "Stupa scroll earned + 3 NPC tasks completed (150 EXP). Library unlocked.", func():
		_jump_library_unlocked()
	)
	
	_add_action_button(vbox, "7. 🏡 Gate 3: Vihara Unlocked (Library Complete + 5 NPC Tasks / 250 EXP)", "Stupa & Library scrolls earned + 5 NPC tasks completed (250 EXP). Vihara unlocked.", func():
		_jump_vihara_unlocked()
	)
	
	_add_action_button(vbox, "8. 📜 All 3 Scrolls Collected (Ready for Final Mastery)", "Stupa, Library & Vihara mastered! All 3 scrolls in inventory.", func():
		_jump_all_scrolls()
	)
	
	_add_action_button(vbox, "9. 🏆 Nalanda 100% Complete (All Grand Mastery Done)", "All 5 final mastery stages finished. Nalanda experience completed.", func():
		_jump_nalanda_complete()
	)
	
	return vbox

# ==============================================================================
# VIEW 2: ALL LANDMARKS & TRIALS
# ==============================================================================
func _build_landmarks_view() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	vbox.add_theme_constant_override("separation", 5)
	
	_add_section_header(vbox, "DIRECT LANDMARK TRIAL LAUNCHERS (3-LIFE SYSTEM)")
	
	_add_action_button(vbox, "🏛️ Great Stupa Trial (Concentration Challenge)", "Opens the 3-life Stupa trial for currently active domain.", func():
		_launch_stupa_challenge()
	)
	
	_add_action_button(vbox, "📚 Dharmaganja Library Trial (Lost Manuscript Investigation)", "Opens the 3-life Library trial for currently active domain.", func():
		_launch_library_challenge()
	)
	
	_add_action_button(vbox, "🏡 Monastic Vihara Trial (Student Life & Coordination)", "Opens the 3-life Vihara trial (Missing items, schedule & dispute).", func():
		_launch_vihara_challenge()
	)
	
	_add_action_button(vbox, "🎓 Teacher 3 Final Grand Mastery Trial", "Opens the 5-domain Grand Synthesis trial UI directly.", func():
		_launch_final_mastery()
	)
	
	_add_action_button(vbox, "🔍 Scholar Reasoning Trial (NPC Clues)", "Opens the clue deduction inspection UI directly.", func():
		_launch_scholar_ui()
	)
	
	return vbox

# ==============================================================================
# VIEW 3: SCENE TELEPORTS
# ==============================================================================
func _build_teleports_view() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	vbox.add_theme_constant_override("separation", 5)
	
	_add_section_header(vbox, "QUICK SCENE TELEPORTATION")
	
	_add_action_button(vbox, "🏰 Nalanda University Campus", "res://scenes/nalanda_university.tscn (Main campus)", func():
		_teleport_to_scene("res://scenes/nalanda_university.tscn", "Nalanda University Campus")
	)
	
	_add_action_button(vbox, "🏞️ Nalanda Exterior / Approach", "res://scenes/nalanda/nalanda.tscn (Outside gate)", func():
		_teleport_to_exterior("Nalanda Exterior Gate")
	)
	
	_add_action_button(vbox, "📚 Ratnasagara Inner Library", "res://scenes/innerLibrary.tscn (Ancient archives)", func():
		_teleport_to_scene("res://scenes/innerLibrary.tscn", "Ratnasagara Inner Library")
	)
	
	_add_action_button(vbox, "🏡 Monastic Inner Vihar", "res://scenes/innerVihar.tscn (Living quarters)", func():
		_teleport_to_scene("res://scenes/innerVihar.tscn", "Monastic Inner Vihar")
	)
	
	_add_action_button(vbox, "🗺️ Experiences Selection Map", "res://scenes/experiences/experiences.tscn", func():
		_teleport_to_scene("res://scenes/experiences/experiences.tscn", "Experiences World Map")
	)
	
	_add_action_button(vbox, "🏠 Main Menu", "res://scenes/main menu/main_menu.tscn", func():
		_teleport_to_scene("res://scenes/main menu/main_menu.tscn", "Main Menu")
	)
	
	return vbox

# ==============================================================================
# VIEW 4: CHEATS & UTILITIES
# ==============================================================================
func _build_cheats_view() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	vbox.add_theme_constant_override("separation", 5)
	
	_add_section_header(vbox, "DEBUG CHEATS & HELPER ACTIONS")
	
	_add_action_button(vbox, "➕ Add +100 EXP", "Increases player EXP and updates progression gates.", func():
		var gs = _get_game_state()
		if gs and gs.has_method("add_exp"):
			gs.add_exp(100)
		_show_toast("+100 EXP Added! (Total: " + str(gs.player_exp if gs else 0) + ")")
	)
	
	_add_action_button(vbox, "🔓 Unlock All 3 Buildings (Stupa, Library, Vihara)", "Sets stupa_unlocked, library_unlocked, and vihara_unlocked to true.", func():
		var gs = _get_game_state()
		if gs:
			gs.stupa_unlocked = true
			gs.library_unlocked = true
			gs.vihara_unlocked = true
			if gs.has_signal("quest_state_changed"):
				gs.quest_state_changed.emit()
		_show_toast("All 3 Buildings Unlocked!")
	)
	
	_add_action_button(vbox, "📜 Award All 3 Landmark Scrolls", "Awards Stupa Scroll, Library Scroll, and Vihara Scroll.", func():
		var gs = _get_game_state()
		if gs:
			gs.stupa_complete = true
			gs.stupa_scroll_earned = true
			gs.library_complete = true
			gs.library_scroll_earned = true
			gs.vihara_complete = true
			gs.vihara_scroll_earned = true
			gs.three_scrolls_collected = true
			gs.final_mastery_unlocked = true
			if gs.has_signal("quest_state_changed"):
				gs.quest_state_changed.emit()
		_show_toast("All 3 Scrolls Awarded!")
	)
	
	_add_action_button(vbox, "✅ Complete All NPC Side Tasks", "Marks all 6 exploration NPC quests as completed (+300 EXP).", func():
		var gs = _get_game_state()
		if gs and "side_quests" in gs:
			for q_id in gs.side_quests:
				gs.side_quests[q_id]["state"] = 2 # COMPLETE
			gs.player_exp = max(gs.player_exp, 300)
			gs.total_accumulated_exp = max(gs.total_accumulated_exp, 300)
			if gs.has_method("check_building_unlocks"):
				gs.check_building_unlocks()
			if gs.has_signal("quest_state_changed"):
				gs.quest_state_changed.emit()
		_show_toast("All NPC Side Quests Completed! (300 EXP)")
	)
	
	_add_action_button(vbox, "🪔 Complete Vihara: Lamp Task", "Lights the study room oil lamp.", func():
		_dev_complete_vihara_task("lamp")
	)
	
	_add_action_button(vbox, "📜 Complete Vihara: Manuscript Task", "Delivers the astronomy manuscript.", func():
		_dev_complete_vihara_task("manuscript")
	)
	
	_add_action_button(vbox, "🏺 Complete Vihara: Water Task", "Arranges the water vessels in the courtyard.", func():
		_dev_complete_vihara_task("water")
	)
	
	_add_action_button(vbox, "✍️ Complete Vihara: Study Space Task", "Prepares the junior student writing desk.", func():
		_dev_complete_vihara_task("study_space")
	)
	
	_add_action_button(vbox, "🔔 Complete Vihara: Ring Evening Bell", "Rings the Evening Bell and completes Vihara!", func():
		_dev_complete_vihara_task("bell")
	)
	
	_add_action_button(vbox, "🔄 Reset Vihara Progress", "Resets Vihara daily tasks and scroll.", func():
		_dev_reset_vihara()
	)
	
	_add_action_button(vbox, "🔄 Reset All Progression to Initial State", "Wipes all progress, resets EXP, scrolls, and locks.", func():
		var gs = _get_game_state()
		if gs:
			_reset_all_game_state(gs)
		_show_toast("All Progress Reset to Initial State.")
	)
	
	return vbox

# ==============================================================================
# UI HELPERS
# ==============================================================================
func _add_section_header(parent: VBoxContainer, title: String) -> void:
	var lbl := Label.new()
	lbl.text = "— " + title + " —"
	lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.4, 1.0))
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(lbl)

func _add_action_button(parent: VBoxContainer, title: String, subtitle: String, callback: Callable) -> void:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 42)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.18, 0.13, 0.09, 0.95)
	sb.border_width_left = 2
	sb.border_width_top = 1
	sb.border_width_right = 1
	sb.border_width_bottom = 2
	sb.border_color = Color(0.7, 0.55, 0.3, 0.9)
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_right = 6
	sb.corner_radius_bottom_left = 6
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	btn.add_theme_stylebox_override("normal", sb)
	
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var t_lbl := Label.new()
	t_lbl.text = title
	t_lbl.add_theme_color_override("font_color", Color(1.0, 0.92, 0.7, 1.0))
	t_lbl.add_theme_font_size_override("font_size", 12)
	t_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(t_lbl)
	
	var s_lbl := Label.new()
	s_lbl.text = subtitle
	s_lbl.add_theme_color_override("font_color", Color(0.75, 0.7, 0.6, 1.0))
	s_lbl.add_theme_font_size_override("font_size", 10)
	s_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(s_lbl)
	
	btn.add_child(vbox)
	btn.pressed.connect(callback)
	parent.add_child(btn)

# ==============================================================================
# DEV MENU TOGGLE & TOAST
# ==============================================================================
func toggle_dev_menu() -> void:
	if not dev_mode_enabled:
		return
	if is_menu_open:
		close_dev_menu()
	else:
		open_dev_menu()

func open_dev_menu() -> void:
	if not dev_mode_enabled:
		return
	_sync_active_domain()
	_update_domain_bar_highlight()
	is_menu_open = true
	if overlay_rect:
		overlay_rect.visible = true
	if main_panel:
		main_panel.visible = true
	var gs = _get_game_state()
	if gs and gs.has_method("lock_player_movement"):
		gs.lock_player_movement()

func close_dev_menu() -> void:
	is_menu_open = false
	if overlay_rect:
		overlay_rect.visible = false
	if main_panel:
		main_panel.visible = false
	var gs = _get_game_state()
	if gs and gs.has_method("unlock_player_movement"):
		gs.unlock_player_movement()

func _show_toast(msg: String) -> void:
	if not toast_banner or not toast_label:
		return
	toast_label.text = "✦ " + msg + " ✦"
	toast_banner.visible = true
	toast_banner.modulate.a = 1.0
	
	var tween := create_tween()
	tween.tween_interval(2.5)
	tween.tween_property(toast_banner, "modulate:a", 0.0, 0.8)
	tween.tween_callback(func(): toast_banner.visible = false)

# ==============================================================================
# JUMP EXECUTION LOGIC
# ==============================================================================
func _get_game_state() -> Node:
	if is_inside_tree():
		var n: Node = get_node_or_null("/root/GameState")
		if n:
			return n
	var ml: MainLoop = Engine.get_main_loop()
	if ml is SceneTree:
		var st: SceneTree = ml as SceneTree
		if st.root:
			var n: Node = st.root.get_node_or_null("GameState")
			if n:
				return n
	return null

func _reset_all_game_state(gs: Node) -> void:
	gs.selected_domain = active_domain_name
	gs.teacher_quiz_completed = false
	gs.teacher_admitted = false
	gs.water_quest_completed = false
	gs.has_visited_university = false
	gs.teacher2_convo_started = false
	gs.has_met_teacher3 = false
	gs.mastery_challenges_unlocked = false
	
	gs.stupa_unlocked = false
	gs.stupa_complete = false
	gs.stupa_scroll_earned = false
	gs.stupa_mastery_completed = false
	
	gs.library_unlocked = false
	gs.library_complete = false
	gs.library_scroll_earned = false
	gs.library_mastery_completed = false
	
	gs.vihara_unlocked = false
	gs.vihara_complete = false
	gs.vihara_scroll_earned = false
	gs.vihara_mastery_completed = false
	
	gs.three_scrolls_collected = false
	gs.final_mastery_unlocked = false
	gs.final_mastery_complete = false
	gs.nalanda_complete = false
	gs.nalanda_completion_reward_claimed = false
	
	gs.player_exp = 0
	gs.total_accumulated_exp = 0
	
	if "side_quests" in gs:
		for q_id in gs.side_quests:
			gs.side_quests[q_id]["state"] = 0 # NOT_STARTED
			if gs.side_quests[q_id].has("progress"):
				gs.side_quests[q_id]["progress"] = 0
			if gs.side_quests[q_id].has("collected_items"):
				gs.side_quests[q_id]["collected_items"] = []
				
	if gs.has_signal("quest_state_changed"):
		gs.quest_state_changed.emit()

func _teleport_to_scene(scene_path: String, scene_name: String) -> void:
	close_dev_menu()
	var tree := get_tree()
	if tree:
		tree.change_scene_to_file(scene_path)
	_show_toast("Teleported to " + scene_name)

func _teleport_to_exterior(title: String) -> void:
	close_dev_menu()
	var path := "res://scenes/nalanda/nalanda.tscn"
	if not ResourceLoader.exists(path):
		path = "res://scenes/nalanda.tscn"
	var tree := get_tree()
	if tree:
		tree.change_scene_to_file(path)
	_show_toast("Teleported to " + title)

# --- 1. Step Jumps ---
func _jump_fresh_start() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
	_teleport_to_scene("res://scenes/main menu/main_menu.tscn", "Game Start / Main Menu")

func _jump_teacher1() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
	_teleport_to_exterior("Teacher 1 (Admission)")

func _jump_teacher2() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_quiz_completed = true
		gs.teacher_admitted = true
		gs.water_quest_completed = true
		gs.merchant_passed = true
		gs.has_visited_university = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_exterior("Teacher 2 (Gatekeeper)")

func _jump_teacher3() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_quiz_completed = true
		gs.teacher_admitted = true
		gs.water_quest_completed = true
		gs.merchant_passed = true
		gs.has_visited_university = true
		gs.teacher2_convo_started = true
		gs.has_met_teacher3 = true
		gs.mastery_challenges_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/nalanda_university.tscn", "Teacher 3 (Campus)")

func _jump_stupa_unlocked() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_admitted = true
		gs.has_visited_university = true
		gs.teacher2_convo_started = true
		gs.has_met_teacher3 = true
		gs.mastery_challenges_unlocked = true
		if "side_quests" in gs and gs.side_quests.has("scribe_manuscript"):
			gs.side_quests["scribe_manuscript"]["state"] = 2
		gs.player_exp = 50
		gs.total_accumulated_exp = 50
		gs.stupa_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/nalanda_university.tscn", "Stupa Unlocked (50 EXP)")

func _jump_library_unlocked() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_admitted = true
		gs.has_visited_university = true
		gs.has_met_teacher3 = true
		gs.mastery_challenges_unlocked = true
		gs.stupa_unlocked = true
		gs.stupa_complete = true
		gs.stupa_scroll_earned = true
		if "side_quests" in gs:
			var keys := ["scribe_manuscript", "farmer_provisions", "stupa_caretaker"]
			for k in keys:
				if gs.side_quests.has(k):
					gs.side_quests[k]["state"] = 2
		gs.player_exp = 150
		gs.total_accumulated_exp = 150
		gs.library_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/nalanda_university.tscn", "Library Unlocked (150 EXP)")

func _jump_vihara_unlocked() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_admitted = true
		gs.has_visited_university = true
		gs.has_met_teacher3 = true
		gs.mastery_challenges_unlocked = true
		gs.stupa_unlocked = true
		gs.stupa_complete = true
		gs.stupa_scroll_earned = true
		gs.library_unlocked = true
		gs.library_complete = true
		gs.library_scroll_earned = true
		if "side_quests" in gs:
			var keys := ["scribe_manuscript", "farmer_provisions", "stupa_caretaker", "vihara_supplies", "missing_student"]
			for k in keys:
				if gs.side_quests.has(k):
					gs.side_quests[k]["state"] = 2
		gs.player_exp = 250
		gs.total_accumulated_exp = 250
		gs.vihara_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/nalanda_university.tscn", "Vihara Unlocked (250 EXP)")

func _jump_all_scrolls() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_admitted = true
		gs.has_visited_university = true
		gs.has_met_teacher3 = true
		gs.stupa_complete = true
		gs.stupa_scroll_earned = true
		gs.library_complete = true
		gs.library_scroll_earned = true
		gs.vihara_complete = true
		gs.vihara_scroll_earned = true
		gs.three_scrolls_collected = true
		gs.final_mastery_unlocked = true
		gs.player_exp = 300
		gs.total_accumulated_exp = 300
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/nalanda_university.tscn", "All 3 Scrolls Collected")

func _jump_nalanda_complete() -> void:
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		gs.selected_domain = active_domain_name
		gs.teacher_admitted = true
		gs.has_visited_university = true
		gs.has_met_teacher3 = true
		gs.stupa_complete = true
		gs.stupa_scroll_earned = true
		gs.library_complete = true
		gs.library_scroll_earned = true
		gs.vihara_complete = true
		gs.vihara_scroll_earned = true
		gs.three_scrolls_collected = true
		gs.final_mastery_unlocked = true
		gs.final_mastery_complete = true
		gs.nalanda_complete = true
		gs.nalanda_completion_reward_claimed = true
		gs.player_exp = 450
		gs.total_accumulated_exp = 450
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
	_teleport_to_scene("res://scenes/experiences/experiences.tscn", "Nalanda 100% Completed")

# --- 2. Direct Trial Launchers ---
func _launch_stupa_challenge() -> void:
	var gs = _get_game_state()
	if gs:
		gs.selected_domain = active_domain_name
		gs.has_met_teacher3 = true
		gs.stupa_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
			
	close_dev_menu()
	var tree := get_tree()
	if tree:
		var scene = tree.current_scene
		if scene and (scene.name == "NalandaUniversity" or scene.name == "Nalanda_University"):
			_open_stupa_ui_in_tree()
		else:
			tree.change_scene_to_file("res://scenes/nalanda_university.tscn")
			_wait_and_open_ui("stupa")
	_show_toast("Launched Great Stupa Challenge (" + active_domain_name.to_upper() + ")")

func _open_stupa_ui_in_tree() -> void:
	var uis := get_tree().get_nodes_in_group("stupa_challenge_ui")
	if uis.size() > 0:
		uis[0].open_challenge(active_domain_name)
	else:
		var scene_res := load("res://scenes/ui/StupaChallengeUI.tscn")
		if scene_res:
			var ui = scene_res.instantiate()
			get_tree().root.add_child(ui)
			ui.open_challenge(active_domain_name)

func _launch_library_challenge() -> void:
	var gs = _get_game_state()
	if gs:
		gs.selected_domain = active_domain_name
		gs.has_met_teacher3 = true
		gs.library_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
			
	close_dev_menu()
	var tree := get_tree()
	if tree:
		var scene = tree.current_scene
		if scene and scene.name == "InnerLibrary":
			_open_library_ui_in_tree()
		else:
			tree.change_scene_to_file("res://scenes/innerLibrary.tscn")
			_wait_and_open_ui("library")
	_show_toast("Launched Library Investigation Challenge (" + active_domain_name.to_upper() + ")")

func _open_library_ui_in_tree() -> void:
	var uis := get_tree().get_nodes_in_group("library_challenge_ui")
	if uis.size() > 0:
		uis[0].open_challenge(active_domain_name)
	else:
		var scene_res := load("res://scenes/ui/LibraryChallengeUI.tscn")
		if scene_res:
			var ui = scene_res.instantiate()
			get_tree().root.add_child(ui)
			ui.open_challenge(active_domain_name)

func _wait_and_open_ui(ui_type: String) -> void:
	var tree := get_tree()
	if not tree:
		return
	for _i in range(12):
		await tree.process_frame
		var cur = tree.current_scene
		if cur:
			var c_name = cur.name.to_lower()
			if ui_type == "library" and ("library" in c_name):
				break
			elif ui_type == "stupa" and ("nalanda" in c_name):
				break
	await tree.process_frame
	match ui_type:
		"stupa": _open_stupa_ui_in_tree()
		"library": _open_library_ui_in_tree()

func _launch_vihara_challenge() -> void:
	var gs = _get_game_state()
	if gs:
		gs.selected_domain = active_domain_name
		gs.has_met_teacher3 = true
		gs.vihara_unlocked = true
		if "pending_arrival_message" in gs:
			gs.pending_arrival_message = []
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
			
	close_dev_menu()
	var tree := get_tree()
	if tree:
		var scene = tree.current_scene
		if scene and (scene.name == "InnerVihar" or scene.name == "innerVihar"):
			_show_toast("Already inside Monastic Vihara")
		else:
			tree.change_scene_to_file("res://scenes/innerVihar.tscn")
	_show_toast("Entered Monastic Vihara (The Evening Bell)")

func _dev_complete_vihara_task(task_id: String) -> void:
	var v_nodes = get_tree().get_nodes_in_group("vihara_manager")
	if v_nodes.size() > 0:
		v_nodes[0].complete_task(task_id)
		_show_toast("Vihara Task Complete: " + task_id.to_upper())
	else:
		var gs = _get_game_state()
		if task_id == "bell" and gs:
			gs.complete_vihara_mastery()
		_show_toast("Vihara Task: " + task_id.to_upper())

func _dev_reset_vihara() -> void:
	var v_nodes = get_tree().get_nodes_in_group("vihara_manager")
	if v_nodes.size() > 0:
		v_nodes[0].reset_vihara_progress()
	var gs = _get_game_state()
	if gs:
		gs.vihara_complete = false
		gs.vihara_scroll_earned = false
		gs.vihara_mastery_completed = false
	_show_toast("Vihara Progress Reset")

func _launch_final_mastery() -> void:
	var gs = _get_game_state()
	if gs:
		gs.selected_domain = active_domain_name
		gs.stupa_complete = true
		gs.stupa_scroll_earned = true
		gs.library_complete = true
		gs.library_scroll_earned = true
		gs.vihara_complete = true
		gs.vihara_scroll_earned = true
		gs.three_scrolls_collected = true
		gs.final_mastery_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
			
	close_dev_menu()
	var tree := get_tree()
	if tree:
		var scene = tree.current_scene
		if scene and (scene.name == "NalandaUniversity" or scene.name == "Nalanda_University"):
			_open_final_mastery_ui_in_tree()
		else:
			tree.change_scene_to_file("res://scenes/nalanda_university.tscn")
			call_deferred("_open_final_mastery_ui_in_tree")
	_show_toast("Launched Teacher 3 Final Grand Mastery (" + active_domain_name.to_upper() + ")")

func _open_final_mastery_ui_in_tree() -> void:
	var uis := get_tree().get_nodes_in_group("final_mastery_ui")
	if uis.size() > 0:
		uis[0].open_ui()
	else:
		var scene_res := load("res://scenes/ui/FinalMasteryUI.tscn")
		if scene_res:
			var ui = scene_res.instantiate()
			get_tree().root.add_child(ui)
			ui.open_ui()

func _launch_scholar_ui() -> void:
	close_dev_menu()
	var tree := get_tree()
	if tree:
		var scene = tree.current_scene
		if scene and (scene.name == "NalandaUniversity" or scene.name == "Nalanda_University"):
			_open_scholar_ui_in_tree()
		else:
			tree.change_scene_to_file("res://scenes/nalanda_university.tscn")
			call_deferred("_open_scholar_ui_in_tree")
	_show_toast("Opened Scholar Reasoning UI (" + active_domain_name.to_upper() + ")")

func _open_scholar_ui_in_tree() -> void:
	var uis := get_tree().get_nodes_in_group("scholar_reasoning_ui")
	if uis.size() > 0:
		uis[0].open_investigation(active_domain_name, "Dev Mode Clue Inspection")
	else:
		var scene_res := load("res://scenes/ui/ScholarReasoningUI.tscn")
		if scene_res:
			var ui = scene_res.instantiate()
			get_tree().root.add_child(ui)
			ui.open_investigation(active_domain_name, "Dev Mode Clue Inspection")

# ==============================================================================
# PASSCODE DEV MODE TOGGLE (ORIGINAL COMPATIBILITY)
# ==============================================================================
func _enable_dev_mode() -> void:
	dev_mode_enabled = true
	var gs = _get_game_state()
	if gs:
		gs.stupa_unlocked = true
		gs.library_unlocked = true
		gs.vihara_unlocked = true
		if gs.has_signal("quest_state_changed"):
			gs.quest_state_changed.emit()
			
	if watermark_label:
		watermark_label.visible = true
		
	_show_toast("DEV MODE ACTIVATED: ALL GATES UNLOCKED (PRESS TAB FOR MENU)")
	print("[DEV MODE] Direct activation successful! All progression unlocked.")

func _disable_dev_mode_and_restart() -> void:
	dev_mode_enabled = false
	if watermark_label:
		watermark_label.visible = false
	var gs = _get_game_state()
	if gs:
		_reset_all_game_state(gs)
		if gs.has_method("unlock_player_movement"):
			gs.unlock_player_movement()
	_show_toast("Dev Mode Deactivated.")
