class_name StupaChallengeUI
extends CanvasLayer

signal challenge_completed(domain: String, difficulty: String)
signal ui_closed()

# UI References
@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_btn: Button = $MainPanel/Header/CloseButton

# Header Labels
@onready var header_title: Label = $MainPanel/Header/TitleLabel
@onready var domain_badge: Label = $MainPanel/Header/DomainBadge
@onready var level_badge: Label = $MainPanel/Header/LevelBadge
@onready var lives_label: Label = $MainPanel/Header/LivesLabel

# Views
@onready var caretaker_view: Control = $MainPanel/Views/CaretakerView
@onready var caretaker_dialogue: Label = $MainPanel/Views/CaretakerView/DialogueBox/DialogueLabel
@onready var btn_begin: Button = $MainPanel/Views/CaretakerView/Buttons/BtnBegin
@onready var btn_not_yet: Button = $MainPanel/Views/CaretakerView/Buttons/BtnNotYet

@onready var game_view: Control = $MainPanel/Views/GameView
@onready var level_intro_label: Label = $MainPanel/Views/GameView/LevelInstruction
@onready var math_container: Control = $MainPanel/Views/GameView/MathContainer
@onready var medicine_container: Control = $MainPanel/Views/GameView/MedicineContainer
@onready var astronomy_container: Control = $MainPanel/Views/GameView/AstronomyContainer
@onready var philosophy_container: Control = $MainPanel/Views/GameView/PhilosophyContainer

@onready var level_complete_view: Control = $MainPanel/Views/LevelCompleteView
@onready var lvl_comp_title: Label = $MainPanel/Views/LevelCompleteView/Title
@onready var lvl_comp_sub: Label = $MainPanel/Views/LevelCompleteView/Subtitle
@onready var lvl_comp_lives: Label = $MainPanel/Views/LevelCompleteView/LivesCarry
@onready var btn_next_level: Button = $MainPanel/Views/LevelCompleteView/BtnNextLevel

@onready var game_over_view: Control = $MainPanel/Views/GameOverView
@onready var game_over_msg: Label = $MainPanel/Views/GameOverView/Message
@onready var btn_retry: Button = $MainPanel/Views/GameOverView/Buttons/BtnRetry
@onready var btn_exit_fail: Button = $MainPanel/Views/GameOverView/Buttons/BtnExit

@onready var mastery_view: Control = $MainPanel/Views/MasteryView
@onready var mastery_dialogue: Label = $MainPanel/Views/MasteryView/DialogueLabel
@onready var btn_finish_mastery: Button = $MainPanel/Views/MasteryView/BtnReturnNalanda

# State
var current_domain: String = "mathematics"
var current_level: int = 1
var lives: int = 3
var is_active: bool = false

# Math Minigame Variables
var math_target_seq: Array = []
var math_current_idx: int = 0
var math_active_tiles: Array = []
var math_spawn_timer: float = 0.0
var math_spawn_interval: float = 1.2
var math_fall_speed: float = 140.0
var math_distractor_pool: Array = []
var math_distractor_chance: float = 0.2
var math_lanes: int = 4
var math_lane_width: float = 120.0
var math_is_running: bool = false
var math_next_target_label: Label = null

# Medicine & Astronomy Match Variables
var match_grid_size: int = 3
var match_cards: Array = []
var match_flipped: Array = []
var match_pairs_left: int = 0
var match_is_processing: bool = false
var match_preview_tween: Tween = null

# Philosophy Variables
var phil_unplaced_cards: Array = []
var phil_placed_cards: Array = []
var phil_expected_order: Array = []
var phil_fallacy_ids: Array = []
var phil_pool_container: HFlowContainer = null
var phil_slots_container: HBoxContainer = null
var phil_feedback_label: Label = null

func _ready() -> void:
	add_to_group("stupa_challenge_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_signals()

func _setup_signals() -> void:
	if close_btn and not close_btn.pressed.is_connected(close_ui):
		close_btn.pressed.connect(close_ui)
		_setup_hover(close_btn)
		
	if btn_begin and not btn_begin.pressed.is_connected(_on_begin_pressed):
		btn_begin.pressed.connect(_on_begin_pressed)
		_setup_hover(btn_begin)
		
	if btn_not_yet and not btn_not_yet.pressed.is_connected(close_ui):
		btn_not_yet.pressed.connect(close_ui)
		_setup_hover(btn_not_yet)
		
	if btn_next_level and not btn_next_level.pressed.is_connected(_on_next_level_pressed):
		btn_next_level.pressed.connect(_on_next_level_pressed)
		_setup_hover(btn_next_level)
		
	if btn_retry and not btn_retry.pressed.is_connected(_on_retry_pressed):
		btn_retry.pressed.connect(_on_retry_pressed)
		_setup_hover(btn_retry)
		
	if btn_exit_fail and not btn_exit_fail.pressed.is_connected(close_ui):
		btn_exit_fail.pressed.connect(close_ui)
		_setup_hover(btn_exit_fail)
		
	if btn_finish_mastery and not btn_finish_mastery.pressed.is_connected(_on_mastery_finished):
		btn_finish_mastery.pressed.connect(_on_mastery_finished)
		_setup_hover(btn_finish_mastery)

func _setup_hover(btn: Button) -> void:
	if not btn:
		return
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.pivot_offset = btn.size / 2.0
	if not btn.mouse_entered.is_connected(_on_btn_hover.bind(btn, true)):
		btn.mouse_entered.connect(_on_btn_hover.bind(btn, true))
	if not btn.mouse_exited.is_connected(_on_btn_hover.bind(btn, false)):
		btn.mouse_exited.connect(_on_btn_hover.bind(btn, false))

func _on_btn_hover(btn: Control, zoom: bool) -> void:
	btn.pivot_offset = btn.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var sc = Vector2(1.04, 1.04) if zoom else Vector2(1.0, 1.0)
	tw.tween_property(btn, "scale", sc, 0.1)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("escape") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if game_over_view and game_over_view.visible:
			close_ui()
		elif mastery_view and mastery_view.visible:
			_on_mastery_finished()
		elif caretaker_view and caretaker_view.visible:
			close_ui()
		else:
			close_ui()
		return
		
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
		
	# 1. Mathematics Piano-Tiles Keyboard & Numpad Controls
	if math_is_running and current_domain == "mathematics":
		var num_val = _get_digit_from_key(event)
		var lane_hit = _get_lane_from_key(event)
		
		# Priority 1: Match falling tile by its exact Number Value (e.g. typing 1, 2, 3.. on numpad)
		if num_val != -1:
			var target_tile = _find_lowest_tile_by_value(num_val)
			if target_tile:
				get_viewport().set_input_as_handled()
				_on_math_tile_clicked(target_tile)
				return
				
		# Priority 2: Match by Lane Index (Lanes 1, 2, 3, 4 / Arrows / ASDF / QWER)
		if lane_hit != -1:
			var lane_tile = _find_lowest_tile_in_lane(lane_hit)
			if lane_tile:
				get_viewport().set_input_as_handled()
				_on_math_tile_clicked(lane_tile)
				return

func _get_digit_from_key(event: InputEventKey) -> int:
	match event.keycode:
		KEY_0, KEY_KP_0: return 0
		KEY_1, KEY_KP_1: return 1
		KEY_2, KEY_KP_2: return 2
		KEY_3, KEY_KP_3: return 3
		KEY_4, KEY_KP_4: return 4
		KEY_5, KEY_KP_5: return 5
		KEY_6, KEY_KP_6: return 6
		KEY_7, KEY_KP_7: return 7
		KEY_8, KEY_KP_8: return 8
		KEY_9, KEY_KP_9: return 9
	match event.physical_keycode:
		KEY_0, KEY_KP_0: return 0
		KEY_1, KEY_KP_1: return 1
		KEY_2, KEY_KP_2: return 2
		KEY_3, KEY_KP_3: return 3
		KEY_4, KEY_KP_4: return 4
		KEY_5, KEY_KP_5: return 5
		KEY_6, KEY_KP_6: return 6
		KEY_7, KEY_KP_7: return 7
		KEY_8, KEY_KP_8: return 8
		KEY_9, KEY_KP_9: return 9
	if event.unicode >= 48 and event.unicode <= 57:
		return event.unicode - 48
	return -1

func _get_lane_from_key(event: InputEventKey) -> int:
	match event.keycode:
		KEY_A, KEY_Q, KEY_LEFT: return 0
		KEY_S, KEY_W, KEY_DOWN: return 1
		KEY_D, KEY_E, KEY_UP: return 2
		KEY_F, KEY_R, KEY_RIGHT: return 3
	return -1

func _find_lowest_tile_by_value(val: int) -> Button:
	var lowest_btn: Button = null
	var max_y: float = -9999.0
	for btn in math_active_tiles:
		if is_instance_valid(btn) and not btn.disabled:
			if btn.get_meta("number_val", -1) == val:
				if btn.position.y > max_y:
					max_y = btn.position.y
					lowest_btn = btn
	return lowest_btn

func _find_lowest_tile_in_lane(lane: int) -> Button:
	var lowest_btn: Button = null
	var max_y: float = -9999.0
	for btn in math_active_tiles:
		if is_instance_valid(btn) and not btn.disabled:
			if btn.get_meta("lane_idx", -1) == lane:
				if btn.position.y > max_y:
					max_y = btn.position.y
					lowest_btn = btn
	return lowest_btn

func open_challenge(forced_domain: String = "") -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		if forced_domain != "":
			current_domain = forced_domain.to_lower()
		elif GameState.selected_domain != "":
			current_domain = GameState.selected_domain.to_lower()
		else:
			current_domain = "mathematics"
	else:
		current_domain = forced_domain if forced_domain != "" else "mathematics"
		
	current_level = 1
	lives = 3
	_update_header()
	_show_caretaker_view()

func close_ui() -> void:
	if match_preview_tween and match_preview_tween.is_valid():
		match_preview_tween.kill()
	math_is_running = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
		
	ui_closed.emit()

func _update_header() -> void:
	var dom_info = StupaChallengeData.get_domain_info(current_domain)
	if domain_badge:
		domain_badge.text = "✦ " + dom_info.get("name", "Mathematics").to_upper() + " ✦"
	if level_badge:
		var tier_name = "INTRODUCTION" if current_level == 1 else ("PRACTICE" if current_level == 2 else "MASTERY")
		level_badge.text = "LEVEL " + str(current_level) + " — " + tier_name
	_update_lives_display()

func _update_lives_display() -> void:
	if not lives_label:
		return
	var hearts_str = ""
	for i in range(3):
		if i < lives:
			hearts_str += "❤️ "
		else:
			hearts_str += "♡ "
	lives_label.text = "LIVES: " + hearts_str.strip_edges()

func _lose_life(reason: String = "") -> void:
	lives = max(0, lives - 1)
	_update_lives_display()
	_flash_screen_red()
	
	if lives <= 0:
		_show_game_over()

func _flash_screen_red() -> void:
	if not color_rect:
		return
	var tw = create_tween()
	tw.tween_property(color_rect, "color", Color(0.6, 0.1, 0.1, 0.75), 0.1)
	tw.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.7), 0.25)

# --- VIEW NAVIGATION ---
func _hide_all_views() -> void:
	if match_preview_tween and match_preview_tween.is_valid():
		match_preview_tween.kill()
	if caretaker_view: caretaker_view.visible = false
	if game_view: game_view.visible = false
	if level_complete_view: level_complete_view.visible = false
	if game_over_view: game_over_view.visible = false
	if mastery_view: mastery_view.visible = false
	math_is_running = false

func _show_caretaker_view() -> void:
	_hide_all_views()
	if caretaker_view:
		caretaker_view.visible = true
	if caretaker_dialogue:
		caretaker_dialogue.text = "“At the Great Stupa, steadying the mind was itself a profound practice.\n\nHere, your learning will be tested not merely by what you know, but by your mindfulness, memory, and concentration.\n\nApply what you have studied with focused attention under the flow of time.\n\nAre you ready?”"

func _on_begin_pressed() -> void:
	_start_level(current_level)

func _start_level(lvl: int) -> void:
	current_level = lvl
	_hide_all_views()
	if game_view:
		game_view.visible = true
	_update_header()
	
	var data = StupaChallengeData.get_challenge(current_domain, current_level)
	if level_intro_label:
		level_intro_label.text = data.get("title", "") + "\n" + data.get("instruction", "")
		
	# Route to domain minigame
	if current_domain == "mathematics":
		_setup_math_minigame(data)
	elif current_domain == "medicine":
		_setup_medicine_minigame(data)
	elif current_domain == "astronomy":
		_setup_astronomy_minigame(data)
	elif current_domain == "philosophy":
		_setup_philosophy_minigame(data)

# ==============================================================================
# 1. MATHEMATICS MINIGAME (Piano-Tiles Style Number Stream)
# ==============================================================================
func _setup_math_minigame(data: Dictionary) -> void:
	_show_only_container(math_container)
	for child in math_container.get_children():
		child.queue_free()
		
	math_target_seq = data.get("target_sequence", [1, 2, 3, 4, 5]).duplicate()
	math_current_idx = 0
	math_fall_speed = data.get("speed", 140.0)
	math_spawn_interval = data.get("spawn_rate", 1.2)
	math_distractor_chance = data.get("distractor_chance", 0.2)
	math_distractor_pool = data.get("distractor_pool", [6, 7, 8, 9])
	math_active_tiles.clear()
	math_spawn_timer = 0.4
	math_is_running = true
	
	math_next_target_label = Label.new()
	math_next_target_label.name = "TargetLabel"
	math_next_target_label.text = _get_math_seq_string()
	math_next_target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	math_next_target_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	math_next_target_label.position = Vector2(0, 10)
	math_next_target_label.size = Vector2(560, 32)
	math_next_target_label.add_theme_font_size_override("font_size", 18)
	math_next_target_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	math_container.add_child(math_next_target_label)
	
	var lanes_bg = ColorRect.new()
	lanes_bg.size = Vector2(520, 300)
	lanes_bg.position = Vector2(20, 50)
	lanes_bg.color = Color(0.08, 0.05, 0.04, 0.6)
	math_container.add_child(lanes_bg)
	
	var hint_lbl = Label.new()
	hint_lbl.text = "⌨️ Keyboard Controls: Type the falling Number on Numpad / Numbers, or use Lanes [A / S / D / F / Arrows]"
	hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_lbl.position = Vector2(20, 355)
	hint_lbl.size = Vector2(520, 20)
	hint_lbl.add_theme_font_size_override("font_size", 10)
	hint_lbl.add_theme_color_override("font_color", Color(0.8, 0.75, 0.65, 0.85))
	math_container.add_child(hint_lbl)

func _get_math_seq_string() -> String:
	var s = "TAP SEQUENCE:  "
	for i in range(math_target_seq.size()):
		var val = str(math_target_seq[i])
		if i < math_current_idx:
			s += "[✓ " + val + "]  "
		elif i == math_current_idx:
			s += "👉 [" + val + "] 👈  "
		else:
			s += "[" + val + "]  "
	return s

func _process(delta: float) -> void:
	if not math_is_running or current_domain != "mathematics":
		return
		
	math_spawn_timer -= delta
	if math_spawn_timer <= 0.0:
		_spawn_math_tile()
		math_spawn_timer = math_spawn_interval
		
	var tiles_to_remove = []
	for tile in math_active_tiles:
		if not is_instance_valid(tile):
			tiles_to_remove.append(tile)
			continue
		tile.position.y += math_fall_speed * delta
		
		if tile.position.y > 340:
			var val = tile.get_meta("number_val", -1)
			var expected = math_target_seq[math_current_idx] if math_current_idx < math_target_seq.size() else -1
			if val == expected:
				_lose_life("Missed target number " + str(val))
			tiles_to_remove.append(tile)
			tile.queue_free()
			
	for r in tiles_to_remove:
		math_active_tiles.erase(r)

func _spawn_math_tile() -> void:
	if math_current_idx >= math_target_seq.size():
		return
		
	var lane_idx = randi() % math_lanes
	var is_target = (randf() > math_distractor_chance)
	var num_val = math_target_seq[math_current_idx]
	
	if not is_target:
		num_val = math_distractor_pool[randi() % math_distractor_pool.size()]
		
	var btn = Button.new()
	btn.size = Vector2(90, 50)
	btn.position = Vector2(40 + lane_idx * 115, 45)
	btn.text = str(num_val)
	btn.add_theme_font_size_override("font_size", 22)
	btn.set_meta("number_val", num_val)
	btn.set_meta("lane_idx", lane_idx)
	
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.35, 0.18, 0.1, 0.95) if is_target else Color(0.22, 0.15, 0.12, 0.9)
	sb.border_color = Color(0.9, 0.7, 0.25) if is_target else Color(0.5, 0.4, 0.3)
	sb.border_width_bottom = 3
	sb.border_width_top = 2
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_left = 6
	sb.corner_radius_bottom_right = 6
	btn.add_theme_stylebox_override("normal", sb)
	
	btn.pressed.connect(_on_math_tile_clicked.bind(btn))
	math_container.add_child(btn)
	math_active_tiles.append(btn)

func _on_math_tile_clicked(btn: Button) -> void:
	if not math_is_running or not is_instance_valid(btn):
		return
		
	var val = btn.get_meta("number_val", -1)
	var expected = math_target_seq[math_current_idx]
	
	if val == expected:
		math_current_idx += 1
		if math_next_target_label:
			math_next_target_label.text = _get_math_seq_string()
			
		btn.disabled = true
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.3, 1.3), 0.1)
		tw.tween_property(btn, "modulate:a", 0.0, 0.15)
		tw.tween_callback(func():
			math_active_tiles.erase(btn)
			btn.queue_free()
		)
		
		if math_current_idx >= math_target_seq.size():
			math_is_running = false
			_on_level_cleared()
	else:
		_lose_life("Tapped incorrect number " + str(val))
		btn.modulate = Color(1.0, 0.3, 0.3)
		var tw = create_tween()
		tw.tween_property(btn, "position:x", btn.position.x + 8, 0.05)
		tw.tween_property(btn, "position:x", btn.position.x - 8, 0.05)
		tw.tween_property(btn, "position:x", btn.position.x, 0.05)

# ==============================================================================
# 2. MEDICINE MINIGAME (Mahjong Herb Matching)
# ==============================================================================
func _setup_medicine_minigame(data: Dictionary) -> void:
	_show_only_container(medicine_container)
	for child in medicine_container.get_children():
		child.queue_free()
		
	match_cards.clear()
	match_flipped.clear()
	match_is_processing = true
	
	var grid_cols = data.get("grid_columns", 4)
	var pairs_count = data.get("pairs_needed", 8)
	var preview_time = data.get("preview_time", 3.0)
	var herb_keys: Array = data.get("herb_keys", []).duplicate()
	
	var deck: Array = []
	for i in range(pairs_count):
		var k = herb_keys[i % herb_keys.size()]
		deck.append(k)
		deck.append(k)
		
	deck.shuffle()
	match_pairs_left = pairs_count
	
	var grid = GridContainer.new()
	grid.columns = grid_cols
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	
	var card_dim = Vector2(78, 68) if grid_cols >= 6 else (Vector2(84, 70) if grid_cols == 5 else Vector2(88, 72))
	var total_w = grid_cols * card_dim.x + (grid_cols - 1) * 8
	var pos_x = max(10.0, (640.0 - total_w) / 2.0)
	grid.position = Vector2(pos_x, 15)
	medicine_container.add_child(grid)
	
	for i in range(deck.size()):
		var herb_id = deck[i]
		var card_btn = _create_match_card(herb_id, "medicine", card_dim)
		grid.add_child(card_btn)
		match_cards.append(card_btn)
		_apply_card_face_up(card_btn)
		
	_start_match_preview(data, preview_time)

# ==============================================================================
# 3. ASTRONOMY MINIGAME (Celestial Observation Patterns)
# ==============================================================================
func _setup_astronomy_minigame(data: Dictionary) -> void:
	_show_only_container(astronomy_container)
	for child in astronomy_container.get_children():
		child.queue_free()
		
	match_cards.clear()
	match_flipped.clear()
	match_is_processing = true
	
	var grid_cols = data.get("grid_columns", 4)
	var pairs_count = data.get("pairs_needed", 8)
	var preview_time = data.get("preview_time", 3.0)
	var celestial_keys: Array = data.get("celestial_keys", []).duplicate()
	
	var deck: Array = []
	for i in range(pairs_count):
		var k = celestial_keys[i % celestial_keys.size()]
		deck.append(k)
		deck.append(k)
		
	deck.shuffle()
	match_pairs_left = pairs_count
	
	var grid = GridContainer.new()
	grid.columns = grid_cols
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	
	var card_dim = Vector2(78, 68) if grid_cols >= 6 else (Vector2(84, 70) if grid_cols == 5 else Vector2(88, 72))
	var total_w = grid_cols * card_dim.x + (grid_cols - 1) * 8
	var pos_x = max(10.0, (640.0 - total_w) / 2.0)
	grid.position = Vector2(pos_x, 15)
	astronomy_container.add_child(grid)
	
	for i in range(deck.size()):
		var celestial_id = deck[i]
		var card_btn = _create_match_card(celestial_id, "astronomy", card_dim)
		grid.add_child(card_btn)
		match_cards.append(card_btn)
		_apply_card_face_up(card_btn)
		
	_start_match_preview(data, preview_time)

func _start_match_preview(data: Dictionary, preview_time: float) -> void:
	if match_preview_tween and match_preview_tween.is_valid():
		match_preview_tween.kill()
		
	var title = data.get("title", "")
	var instruction = data.get("instruction", "")
	
	if level_intro_label:
		level_intro_label.text = title + "\n" + "👀 MEMORIZE TILES! (" + str(int(preview_time)) + "s)"
		level_intro_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		
	match_preview_tween = create_tween()
	var total_sec = int(preview_time)
	for s in range(total_sec, 0, -1):
		match_preview_tween.tween_interval(1.0)
		var sec_remaining = s - 1
		match_preview_tween.tween_callback(func():
			if sec_remaining > 0 and is_instance_valid(level_intro_label):
				level_intro_label.text = title + "\n" + "👀 MEMORIZE TILES! (" + str(sec_remaining) + "s)"
		)
		
	match_preview_tween.tween_callback(func():
		for card in match_cards:
			if is_instance_valid(card) and not card.get_meta("is_matched", false):
				card.set_meta("is_revealed", false)
				_apply_card_face_down(card)
		match_is_processing = false
		if is_instance_valid(level_intro_label):
			level_intro_label.text = title + "\n" + instruction
			level_intro_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.75))
	)

func _create_match_card(item_id: String, domain_type: String, dim: Vector2) -> Button:
	var btn = Button.new()
	btn.custom_minimum_size = dim
	btn.size = dim
	btn.set_meta("item_id", item_id)
	btn.set_meta("domain_type", domain_type)
	btn.set_meta("is_revealed", false)
	btn.set_meta("is_matched", false)
	
	_apply_card_face_down(btn)
	btn.pressed.connect(_on_match_card_clicked.bind(btn))
	_setup_hover(btn)
	return btn

func _apply_card_face_down(btn: Button) -> void:
	btn.text = "✦"
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.18, 0.12, 0.09, 0.95)
	sb.border_color = Color(0.65, 0.45, 0.2)
	sb.border_width_bottom = 2
	sb.border_width_top = 2
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_left = 6
	sb.corner_radius_bottom_right = 6
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_font_size_override("font_size", 18)
	btn.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))

func _apply_card_face_up(btn: Button) -> void:
	var item_id = btn.get_meta("item_id", "")
	var domain_type = btn.get_meta("domain_type", "medicine")
	
	var icon = "🌸"
	var item_name = "Lotus"
	var col = Color(0.95, 0.8, 0.3)
	
	if item_id == "bonus":
		icon = "🏵️"
		item_name = "Nalanda\nSeal"
		col = Color(1.0, 0.85, 0.2)
	elif domain_type == "medicine" and StupaChallengeData.HERBS.has(item_id):
		var h = StupaChallengeData.HERBS[item_id]
		icon = h.get("icon", "🌿")
		item_name = h.get("name", item_id)
		col = h.get("color", Color(0.3, 0.8, 0.4))
	elif domain_type == "astronomy" and StupaChallengeData.CELESTIALS.has(item_id):
		var c = StupaChallengeData.CELESTIALS[item_id]
		icon = c.get("icon", "☀️")
		item_name = c.get("name", item_id)
		col = c.get("color", Color(1.0, 0.8, 0.3))
		
	btn.text = icon + "\n" + item_name
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.28, 0.18, 0.12, 0.98)
	sb.border_color = col
	sb.border_width_bottom = 3
	sb.border_width_top = 2
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_left = 6
	sb.corner_radius_bottom_right = 6
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_font_size_override("font_size", 12 if btn.size.x < 80 else 14)
	btn.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))

func _on_match_card_clicked(btn: Button) -> void:
	if match_is_processing or not is_instance_valid(btn):
		return
	if btn.get_meta("is_revealed", false) or btn.get_meta("is_matched", false):
		return
		
	var item_id = btn.get_meta("item_id", "")
	
	if item_id == "bonus":
		btn.set_meta("is_revealed", true)
		btn.set_meta("is_matched", true)
		_apply_card_face_up(btn)
		btn.modulate = Color(1.0, 0.9, 0.4)
		return
		
	btn.set_meta("is_revealed", true)
	_apply_card_face_up(btn)
	match_flipped.append(btn)
	
	if match_flipped.size() == 2:
		match_is_processing = true
		var card1: Button = match_flipped[0]
		var card2: Button = match_flipped[1]
		var id1 = card1.get_meta("item_id", "")
		var id2 = card2.get_meta("item_id", "")
		
		if id1 == id2:
			card1.set_meta("is_matched", true)
			card2.set_meta("is_matched", true)
			card1.disabled = true
			card2.disabled = true
			
			var tw = create_tween()
			tw.tween_property(card1, "modulate", Color(0.4, 1.0, 0.4), 0.15)
			tw.parallel().tween_property(card2, "modulate", Color(0.4, 1.0, 0.4), 0.15)
			tw.tween_property(card1, "modulate:a", 0.35, 0.2)
			tw.parallel().tween_property(card2, "modulate:a", 0.35, 0.2)
			
			match_flipped.clear()
			match_pairs_left -= 1
			
			if match_pairs_left <= 0:
				match_is_processing = false
				_on_level_cleared()
			else:
				var data = StupaChallengeData.get_challenge(current_domain, current_level)
				var preview_time = data.get("preview_time", 3.0)
				for card in match_cards:
					if is_instance_valid(card) and not card.get_meta("is_matched", false):
						card.set_meta("is_revealed", true)
						_apply_card_face_up(card)
				_start_match_preview(data, preview_time)
		else:
			_lose_life("Mismatched botanical / celestial pair")
			var tw = create_tween()
			tw.tween_property(card1, "modulate", Color(1.0, 0.3, 0.3), 0.1)
			tw.parallel().tween_property(card2, "modulate", Color(1.0, 0.3, 0.3), 0.1)
			tw.tween_interval(1.0)
			tw.tween_callback(func():
				if is_instance_valid(card1) and not card1.get_meta("is_matched", false):
					card1.set_meta("is_revealed", false)
					card1.modulate = Color(1, 1, 1, 1)
					_apply_card_face_down(card1)
				if is_instance_valid(card2) and not card2.get_meta("is_matched", false):
					card2.set_meta("is_revealed", false)
					card2.modulate = Color(1, 1, 1, 1)
					_apply_card_face_down(card2)
				match_flipped.clear()
				match_is_processing = false
			)

# ==============================================================================
# 4. PHILOSOPHY MINIGAME (Nyaya Logic Tiles)
# ==============================================================================
func _setup_philosophy_minigame(data: Dictionary) -> void:
	_show_only_container(philosophy_container)
	for child in philosophy_container.get_children():
		child.queue_free()
		
	phil_unplaced_cards.clear()
	phil_placed_cards.clear()
	phil_expected_order = data.get("expected_order", []).duplicate()
	phil_fallacy_ids = data.get("fallacy_ids", []).duplicate()
	
	var vbox = VBoxContainer.new()
	vbox.position = Vector2(10, 10)
	vbox.size = Vector2(580, 310)
	vbox.add_theme_constant_override("separation", 8)
	philosophy_container.add_child(vbox)
	
	var slots_label = Label.new()
	slots_label.text = "⚖️ DEDUCTIVE SYLLOGISM SEQUENCE (Click unplaced cards to slot into chain):"
	slots_label.add_theme_font_size_override("font_size", 13)
	slots_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	vbox.add_child(slots_label)
	
	phil_slots_container = HBoxContainer.new()
	phil_slots_container.custom_minimum_size = Vector2(580, 75)
	phil_slots_container.add_theme_constant_override("separation", 6)
	vbox.add_child(phil_slots_container)
	
	var pool_label = Label.new()
	pool_label.text = "📜 AVAILABLE STATEMENTS & FALLACIES (Click to place):"
	pool_label.add_theme_font_size_override("font_size", 13)
	pool_label.add_theme_color_override("font_color", Color(0.85, 0.75, 0.6))
	vbox.add_child(pool_label)
	
	phil_pool_container = HFlowContainer.new()
	phil_pool_container.custom_minimum_size = Vector2(580, 120)
	phil_pool_container.add_theme_constant_override("h_separation", 6)
	phil_pool_container.add_theme_constant_override("v_separation", 6)
	vbox.add_child(phil_pool_container)
	
	var action_row = HBoxContainer.new()
	action_row.custom_minimum_size = Vector2(580, 38)
	action_row.add_theme_constant_override("separation", 15)
	vbox.add_child(action_row)
	
	phil_feedback_label = Label.new()
	phil_feedback_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phil_feedback_label.text = "Assemble the chain in valid deductive order and exclude any fallacy."
	phil_feedback_label.add_theme_font_size_override("font_size", 12)
	phil_feedback_label.add_theme_color_override("font_color", Color(0.8, 0.75, 0.65))
	action_row.add_child(phil_feedback_label)
	
	var submit_btn = Button.new()
	submit_btn.custom_minimum_size = Vector2(180, 36)
	submit_btn.text = "VALIDATE SYLLOGISM ✦"
	submit_btn.add_theme_font_size_override("font_size", 13)
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.4, 0.22, 0.12)
	sb.border_color = Color(0.9, 0.75, 0.3)
	sb.border_width_bottom = 2
	sb.border_width_top = 2
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.corner_radius_top_left = 5
	sb.corner_radius_top_right = 5
	sb.corner_radius_bottom_left = 5
	sb.corner_radius_bottom_right = 5
	submit_btn.add_theme_stylebox_override("normal", sb)
	submit_btn.pressed.connect(_on_philosophy_submit)
	_setup_hover(submit_btn)
	action_row.add_child(submit_btn)
	
	var raw_cards: Array = data.get("cards", []).duplicate()
	raw_cards.shuffle()
	
	for c in raw_cards:
		var card_btn = Button.new()
		card_btn.custom_minimum_size = Vector2(135, 55)
		card_btn.text = c.get("tag", "") + "\n" + c.get("text", "")
		card_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card_btn.add_theme_font_size_override("font_size", 10)
		card_btn.set_meta("card_data", c)
		card_btn.set_meta("is_placed", false)
		
		var csb = StyleBoxFlat.new()
		csb.bg_color = Color(0.2, 0.14, 0.1, 0.95)
		csb.border_color = Color(0.7, 0.55, 0.3)
		csb.border_width_bottom = 2
		csb.border_width_top = 1
		csb.border_width_left = 1
		csb.border_width_right = 1
		csb.corner_radius_top_left = 4
		csb.corner_radius_top_right = 4
		csb.corner_radius_bottom_left = 4
		csb.corner_radius_bottom_right = 4
		card_btn.add_theme_stylebox_override("normal", csb)
		card_btn.pressed.connect(_on_phil_card_clicked.bind(card_btn))
		_setup_hover(card_btn)
		
		phil_pool_container.add_child(card_btn)
		phil_unplaced_cards.append(card_btn)

func _on_phil_card_clicked(btn: Button) -> void:
	if not is_instance_valid(btn):
		return
	var is_placed = btn.get_meta("is_placed", false)
	if is_placed:
		btn.get_parent().remove_child(btn)
		phil_pool_container.add_child(btn)
		phil_placed_cards.erase(btn)
		phil_unplaced_cards.append(btn)
		btn.set_meta("is_placed", false)
	else:
		btn.get_parent().remove_child(btn)
		phil_slots_container.add_child(btn)
		phil_unplaced_cards.erase(btn)
		phil_placed_cards.append(btn)
		btn.set_meta("is_placed", true)

func _on_philosophy_submit() -> void:
	if phil_placed_cards.is_empty():
		if phil_feedback_label:
			phil_feedback_label.text = "⚠️ Place the logic statements into the chain first."
		return
		
	var placed_ids = []
	var contains_fallacy = false
	var fallacy_reason = ""
	
	for btn in phil_placed_cards:
		var cdata = btn.get_meta("card_data", {})
		var cid = cdata.get("id", "")
		placed_ids.append(cid)
		if cdata.get("is_fallacy", false):
			contains_fallacy = true
			fallacy_reason = cdata.get("explanation", "Fallacy detected.")
			
	if contains_fallacy:
		_lose_life("Fallacy placed: " + fallacy_reason)
		if phil_feedback_label:
			phil_feedback_label.text = "❌ " + fallacy_reason
			phil_feedback_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		return
		
	if placed_ids == phil_expected_order:
		if phil_feedback_label:
			phil_feedback_label.text = "✨ Perfect Nyaya Syllogism deduction!"
			phil_feedback_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
		_on_level_cleared()
	else:
		_lose_life("Invalid logical progression order")
		if phil_feedback_label:
			phil_feedback_label.text = "❌ Flawed sequence. Nyaya deduction requires: Claim → Reason → Universal Rule → Application → Conclusion."
			phil_feedback_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))

# ==============================================================================
# VIEW CONTAINERS HELPER
# ==============================================================================
func _show_only_container(active: Control) -> void:
	if math_container: math_container.visible = (active == math_container)
	if medicine_container: medicine_container.visible = (active == medicine_container)
	if astronomy_container: astronomy_container.visible = (active == astronomy_container)
	if philosophy_container: philosophy_container.visible = (active == philosophy_container)

# ==============================================================================
# LEVEL CLEARED & LEVEL COMPLETE / MASTERY
# ==============================================================================
func _on_level_cleared() -> void:
	if current_level < 3:
		_show_level_complete_modal()
	else:
		_show_mastery_complete_modal()

func _show_level_complete_modal() -> void:
	_hide_all_views()
	if level_complete_view:
		level_complete_view.visible = true
	if lvl_comp_title:
		lvl_comp_title.text = "✨ LEVEL " + str(current_level) + " COMPLETE! ✨"
	if lvl_comp_sub:
		var next_tier = "Practice" if current_level == 1 else "Mastery"
		lvl_comp_sub.text = "Concentration sustained. Ready to proceed to Level " + str(current_level + 1) + " (" + next_tier + ")."
	if lvl_comp_lives:
		var hearts_str = ""
		for i in range(3):
			hearts_str += "❤️ " if i < lives else "♡ "
		lvl_comp_lives.text = "Lives Carried Forward: " + hearts_str.strip_edges() + "\n(Lives DO NOT reset between levels)"

func _on_next_level_pressed() -> void:
	_start_level(current_level + 1)

func _show_game_over() -> void:
	math_is_running = false
	_hide_all_views()
	if game_over_view:
		game_over_view.visible = true
	if game_over_msg:
		game_over_msg.text = "“Recenter your focus and steady your mind. Endeavor once more.”\n\n(Concentration broken. Retry from Level 1 with 3 lives or return to Nalanda.)"

func _on_retry_pressed() -> void:
	current_level = 1
	lives = 3
	_start_level(1)

func _show_mastery_complete_modal() -> void:
	math_is_running = false
	_hide_all_views()
	if mastery_view:
		mastery_view.visible = true
	if mastery_dialogue:
		mastery_dialogue.text = "“You have done more than complete three levels.\n\nYou have unified your attention, discernment, and learning into true mastery.”"
		
	if GameState:
		GameState.complete_stupa_mastery()
	challenge_completed.emit(current_domain, "hard")

func _on_mastery_finished() -> void:
	close_ui()
