extends CanvasLayer

# ==================================================
# CONFIGURATION
# ==================================================
const DEV_MODE_AVAILABLE: bool = true
const TARGET_SEQUENCE: String = "278007"
const DEV_TIMEOUT: float = 3.0

# ==================================================
# SESSION STATE (In-Memory Only)
# ==================================================
var dev_mode_enabled: bool = false
var _current_sequence: String = ""
var _last_press_time: float = 0.0

# UI Nodes
var watermark_label: Label
var toast_banner: PanelContainer
var toast_label: Label

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if not DEV_MODE_AVAILABLE:
		return
		
	_build_ui()

func _input(event: InputEvent) -> void:
	if not DEV_MODE_AVAILABLE:
		return
		
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		# Sequence detection for digits '2', '7', '8', '0', '0', '7'
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
	if event.unicode >= 48 and event.unicode <= 57: # '0'..'9'
		return String.chr(event.unicode)
	return ""

# ==================================================
# UI CONSTRUCTION
# ==================================================
func _build_ui() -> void:
	# 1. Subtle Watermark Label (shown when Dev Mode is active)
	watermark_label = Label.new()
	watermark_label.text = "✦ DEV MODE ACTIVE ✦"
	watermark_label.modulate = Color(1.0, 0.85, 0.4, 0.75)
	watermark_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	watermark_label.position = Vector2(16, 12)
	watermark_label.visible = false
	watermark_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(watermark_label)
	
	# 2. Toast Notification Banner (briefly animates at top when enabled)
	_build_toast_banner()

func _build_toast_banner() -> void:
	toast_banner = PanelContainer.new()
	toast_banner.set_anchors_preset(Control.PRESET_CENTER_TOP)
	toast_banner.offset_left = -280
	toast_banner.offset_top = 18
	toast_banner.offset_right = 280
	toast_banner.offset_bottom = 58
	toast_banner.visible = false
	toast_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.08, 0.05, 0.92)
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
	style.content_margin_top = 8
	style.content_margin_right = 16
	style.content_margin_bottom = 8
	toast_banner.add_theme_stylebox_override("panel", style)
	
	toast_label = Label.new()
	toast_label.text = "✦ DEV MODE: ALL GATES UNLOCKED — FREE EXPLORATION ✦"
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5, 1.0))
	toast_label.add_theme_font_size_override("font_size", 13)
	toast_banner.add_child(toast_label)
	
	add_child(toast_banner)

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

func _enable_dev_mode() -> void:
	dev_mode_enabled = true
	
	# Unlock all progression immediately so player can freely explore everywhere
	var gs = _get_game_state()
	if gs and gs.has_method("unlock_all_progression"):
		gs.unlock_all_progression()
		
	if watermark_label:
		watermark_label.visible = true
		
	_show_toast_notification()
	print("[DEV MODE] Direct activation successful! All progression unlocked. Free exploration active.")

func _disable_dev_mode_and_restart() -> void:
	dev_mode_enabled = false
	if watermark_label:
		watermark_label.visible = false
	if toast_banner:
		toast_banner.visible = false
		
	var gs = _get_game_state()
	if gs:
		if gs.has_method("reset_test_progression"):
			gs.reset_test_progression()
		if gs.has_method("unlock_player_movement"):
			gs.unlock_player_movement()
			
	print("[DEV MODE] Dev Mode turned OFF. Restarting Nalanda from beginning.")
	get_tree().change_scene_to_file("res://scenes/nalanda.tscn")

func _show_toast_notification() -> void:
	if not toast_banner:
		return
	toast_banner.visible = true
	toast_banner.modulate.a = 1.0
	
	# Animate fade out after 3 seconds
	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_property(toast_banner, "modulate:a", 0.0, 1.0)
	tween.tween_callback(func(): toast_banner.visible = false)
