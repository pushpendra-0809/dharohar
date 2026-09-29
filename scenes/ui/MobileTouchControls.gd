extends CanvasLayer

# ==============================================================================
# DHAROHAR - MOBILE TOUCH CONTROLS & VIRTUAL ANALOG JOYSTICK
# Only active on real mobile devices (Android / iOS). 100% hidden on PC/Desktop.
# ==============================================================================

var is_mobile: bool = false

# Joystick touch tracking
var joystick_touch_id: int = -1
var joystick_center: Vector2 = Vector2.ZERO
var joystick_pos: Vector2 = Vector2.ZERO
var max_radius: float = 65.0
var deadzone: float = 12.0
var move_vector: Vector2 = Vector2.ZERO

# Active simulated input states
var _active_left: bool = false
var _active_right: bool = false
var _active_up: bool = false
var _active_down: bool = false

@onready var container: Control = $Control
@onready var joystick_base: Control = $Control/JoystickBase
@onready var joystick_knob: Control = $Control/JoystickBase/Knob

func _ready() -> void:
	layer = 125
	_detect_platform()
	_update_visibility()

func _detect_platform() -> void:
	if OS.has_feature("web"):
		# Check exact User-Agent & Touchscreen in Web Browser
		var is_touch_ua = JavaScriptBridge.eval("Boolean(navigator.maxTouchPoints > 0 && /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent))")
		is_mobile = (is_touch_ua == true)
	elif OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		is_mobile = true
	else:
		is_mobile = false

func _update_visibility() -> void:
	if container:
		container.visible = is_mobile
		container.set_process_input(is_mobile)

func _input(event: InputEvent) -> void:
	if not is_mobile:
		return

	# Handle Screen Touch (Touch Down / Up)
	if event is InputEventScreenTouch:
		if event.pressed:
			_handle_touch_down(event.index, event.position)
		else:
			_handle_touch_up(event.index, event.position)

	# Handle Screen Drag (Finger Moving)
	elif event is InputEventScreenDrag:
		_handle_touch_drag(event.index, event.position)

func _handle_touch_down(touch_id: int, pos: Vector2) -> void:
	var vp_size = get_viewport().get_visible_rect().size
	
	# Left 45% of screen = Virtual Joystick
	if pos.x < vp_size.x * 0.45 and pos.y > vp_size.y * 0.35:
		if joystick_touch_id == -1:
			joystick_touch_id = touch_id
			joystick_center = pos
			if joystick_base:
				joystick_base.global_position = joystick_center - (joystick_base.size * 0.5)
				joystick_base.modulate.a = 0.85
			if joystick_knob:
				joystick_knob.position = (joystick_base.size * 0.5) - (joystick_knob.size * 0.5)
	else:
		# Right side touch = Tap to Interact on Mobile
		_trigger_interact()

func _handle_touch_drag(touch_id: int, pos: Vector2) -> void:
	if touch_id == joystick_touch_id:
		var diff = pos - joystick_center
		var dist = diff.length()
		
		if dist > max_radius:
			diff = diff.normalized() * max_radius
			
		joystick_pos = diff
		
		if joystick_knob and joystick_base:
			joystick_knob.position = (joystick_base.size * 0.5) - (joystick_knob.size * 0.5) + diff
			
		if dist > deadzone:
			move_vector = diff.normalized()
		else:
			move_vector = Vector2.ZERO
			
		_apply_movement_actions(move_vector)

func _handle_touch_up(touch_id: int, _pos: Vector2) -> void:
	if touch_id == joystick_touch_id:
		joystick_touch_id = -1
		move_vector = Vector2.ZERO
		_apply_movement_actions(Vector2.ZERO)
		
		if joystick_knob and joystick_base:
			joystick_knob.position = (joystick_base.size * 0.5) - (joystick_knob.size * 0.5)
			joystick_base.modulate.a = 0.45

func _apply_movement_actions(vec: Vector2) -> void:
	var want_left = (vec.x < -0.3)
	var want_right = (vec.x > 0.3)
	var want_up = (vec.y < -0.3)
	var want_down = (vec.y > 0.3)

	if want_left != _active_left:
		_set_action("left", want_left)
		_active_left = want_left
		
	if want_right != _active_right:
		_set_action("right", want_right)
		_active_right = want_right
		
	if want_up != _active_up:
		_set_action("forward", want_up)
		_active_up = want_up
		
	if want_down != _active_down:
		_set_action("backward", want_down)
		_active_down = want_down

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
