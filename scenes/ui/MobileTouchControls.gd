extends CanvasLayer

class_name MobileTouchControls

# Autoload / Global Touch Controls for Mobile (Android, iOS & Touch Web)
var is_touch_device: bool = false
var left_pressed: bool = false
var right_pressed: bool = false
var up_pressed: bool = false
var down_pressed: bool = false

@onready var container: Control = $Control
@onready var dpad_container: Control = $Control/DPadContainer
@onready var action_container: Control = $Control/ActionContainer

func _ready() -> void:
	layer = 120 # Above game world, below modals/dialogues
	_detect_touch_platform()
	_setup_buttons()

func _detect_touch_platform() -> void:
	# Check web mobile features, OS platform, or touch display
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		is_touch_device = true
	else:
		# Fallback: check if running on web
		if OS.has_feature("web"):
			# Visible by default on web with touch detection
			is_touch_device = true

	if container:
		container.visible = is_touch_device

func _input(event: InputEvent) -> void:
	# If any touch or screen drag event occurs, ensure touch controls are visible
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and container and not container.visible:
		container.visible = true
		is_touch_device = true

func _setup_buttons() -> void:
	var btn_up = get_node_or_null("Control/DPadContainer/BtnUp")
	var btn_down = get_node_or_null("Control/DPadContainer/BtnDown")
	var btn_left = get_node_or_null("Control/DPadContainer/BtnLeft")
	var btn_right = get_node_or_null("Control/DPadContainer/BtnRight")
	var btn_interact = get_node_or_null("Control/ActionContainer/BtnInteract")

	if btn_up:
		btn_up.button_down.connect(func(): _set_action("forward", true))
		btn_up.button_up.connect(func(): _set_action("forward", false))
	if btn_down:
		btn_down.button_down.connect(func(): _set_action("backward", true))
		btn_down.button_up.connect(func(): _set_action("backward", false))
	if btn_left:
		btn_left.button_down.connect(func(): _set_action("left", true))
		btn_left.button_up.connect(func(): _set_action("left", false))
	if btn_right:
		btn_right.button_down.connect(func(): _set_action("right", true))
		btn_right.button_up.connect(func(): _set_action("right", false))
	if btn_interact:
		btn_interact.button_down.connect(func(): _trigger_interact())

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
	
	# Release shortly after
	get_tree().create_timer(0.1).timeout.connect(func():
		var ev_up = InputEventAction.new()
		ev_up.action = "interact"
		ev_up.pressed = false
		Input.parse_input_event(ev_up)
	)
