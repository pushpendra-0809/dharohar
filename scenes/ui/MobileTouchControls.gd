extends CanvasLayer

# ==============================================================================
# DHAROHAR - ROBUST MOBILE TOUCH CONTROLS
# Automatically activates on Touch / Mobile browsers (Android & iOS).
# Completely hidden on Desktop PC / Mouse-only.
# ==============================================================================

var is_mobile: bool = false
var is_dragging_joystick: bool = false
var active_touch_id: int = -1
var joystick_radius: float = 55.0
var joystick_center: Vector2 = Vector2.ZERO

# Simulated key states
var _moving_left: bool = false
var _moving_right: bool = false
var _moving_up: bool = false
var _moving_down: bool = false

@onready var container: Control = $Control
@onready var joystick_base: Control = $Control/JoystickBase
@onready var joystick_knob: Control = $Control/JoystickBase/Knob
@onready var btn_interact: Button = $Control/BtnInteract

func _ready() -> void:
	layer = 125
	_detect_platform()
	_setup_interact_button()
	_update_ui_state()

func _detect_platform() -> void:
	if OS.has_feature("web"):
		# Check touch capabilities in Web browser
		var check_touch = JavaScriptBridge.eval("Boolean('ontouchstart' in window || navigator.maxTouchPoints > 0 || /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent))")
		if check_touch == true:
			is_mobile = true
	elif OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios") or DisplayServer.is_touchscreen_available():
		is_mobile = true

func _update_ui_state() -> void:
	if container:
		container.visible = is_mobile
	if joystick_base and joystick_knob:
		joystick_center = joystick_base.size * 0.5
		joystick_knob.position = joystick_center - (joystick_knob.size * 0.5)

func _setup_interact_button() -> void:
	if btn_interact:
		btn_interact.button_down.connect(_on_interact_pressed)

func _on_interact_pressed() -> void:
	_trigger_interact()

func _input(event: InputEvent) -> void:
	# If any touch event arrives on Web/Native, guarantee mobile controls become active
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and not is_mobile:
		is_mobile = true
		_update_ui_state()

	if not is_mobile or not container or not container.visible:
		return

	# Handle Screen Touch (Real Mobile Device)
	if event is InputEventScreenTouch:
		if event.pressed:
			_handle_pointer_down(event.index, event.position)
		else:
			_handle_pointer_up(event.index, event.position)

	elif event is InputEventScreenDrag:
		_handle_pointer_drag(event.index, event.position)

	# Handle Mouse Events when emulated on Web Mobile
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_handle_pointer_down(0, event.position)
			else:
				_handle_pointer_up(0, event.position)

	elif event is InputEventMouseMotion:
		if is_dragging_joystick and active_touch_id == 0:
			_handle_pointer_drag(0, event.position)

func _handle_pointer_down(id: int, pos: Vector2) -> void:
	if not joystick_base:
		return
		
	var base_rect = joystick_base.get_global_rect()
	# Expand touch detection area around joystick
	var expanded_rect = base_rect.grow(40.0)
	
	if expanded_rect.has_point(pos):
		is_dragging_joystick = true
		active_touch_id = id
		_update_joystick_knob(pos)
	else:
		# Check if touch is on the right side of the screen (tap to interact)
		var vp_width = get_viewport().get_visible_rect().size.x
		if pos.x > vp_width * 0.5 and pos.y > 100.0:
			_trigger_interact()

func _handle_pointer_drag(id: int, pos: Vector2) -> void:
	if is_dragging_joystick and id == active_touch_id:
		_update_joystick_knob(pos)

func _handle_pointer_up(id: int, _pos: Vector2) -> void:
	if is_dragging_joystick and id == active_touch_id:
		is_dragging_joystick = false
		active_touch_id = -1
		_reset_joystick()

func _update_joystick_knob(global_pos: Vector2) -> void:
	if not joystick_base or not joystick_knob:
		return
		
	var base_global_center = joystick_base.global_position + (joystick_base.size * 0.5)
	var offset = global_pos - base_global_center
	var dist = offset.length()
	
	if dist > joystick_radius:
		offset = offset.normalized() * joystick_radius
		
	joystick_knob.position = (joystick_base.size * 0.5) - (joystick_knob.size * 0.5) + offset
	
	# Direction Vector (Normalized)
	var move_vec = Vector2.ZERO
	if dist > 10.0:
		move_vec = offset / joystick_radius
		
	_apply_movement(move_vec)

func _reset_joystick() -> void:
	if joystick_base and joystick_knob:
		joystick_knob.position = (joystick_base.size * 0.5) - (joystick_knob.size * 0.5)
	_apply_movement(Vector2.ZERO)

func _apply_movement(vec: Vector2) -> void:
	var want_left = (vec.x < -0.28)
	var want_right = (vec.x > 0.28)
	var want_up = (vec.y < -0.28)
	var want_down = (vec.y > 0.28)

	if want_left != _moving_left:
		_set_action("left", want_left)
		_moving_left = want_left
		
	if want_right != _moving_right:
		_set_action("right", want_right)
		_moving_right = want_right
		
	if want_up != _moving_up:
		_set_action("forward", want_up)
		_moving_up = want_up
		
	if want_down != _moving_down:
		_set_action("backward", want_down)
		_moving_down = want_down

func _set_action(action_name: String, pressed: bool) -> void:
	var ev = InputEventAction.new()
	ev.action = action_name
	ev.pressed = pressed
	Input.parse_input_event(ev)

func _trigger_interact() -> void:
	var ev_down = InputEventAction.new()
	ev_down.action = "interact"
	ev_down.pressed = true
	Input.parse_input_event(ev_down)
	
	get_tree().create_timer(0.12).timeout.connect(func():
		var ev_up = InputEventAction.new()
		ev_up.action = "interact"
		ev_up.pressed = false
		Input.parse_input_event(ev_up)
	)
