extends StaticBody2D

var _player_in_range: bool = false
var _notification_active: bool = false

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var notification_label: Label = $NotificationLabel
@onready var notification_timer: Timer = $NotificationTimer

func _ready() -> void:
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)

	if notification_timer and not notification_timer.timeout.is_connected(_on_notification_timeout):
		notification_timer.timeout.connect(_on_notification_timeout)

	_update_ui_elements()

func _is_dev_mode() -> bool:
	var dev = get_node_or_null("/root/DevModeManager")
	return dev != null and dev.dev_mode_enabled

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range:
		if event.is_action_pressed("interact"):
			if _is_dev_mode():
				get_viewport().set_input_as_handled()
				_collect_water()
			elif GameState and GameState.merchant_water_quest_started and not GameState.water_collected:
				get_viewport().set_input_as_handled()
				_collect_water()
			elif GameState and GameState.water_collected:
				get_viewport().set_input_as_handled()
				_show_notification("The vessel is already filled.")

func _collect_water() -> void:
	if GameState:
		GameState.collect_water()
	_update_ui_elements()
	_show_notification("Water collected!")

func _show_notification(text: String) -> void:
	if notification_label:
		notification_label.text = text
		notification_label.visible = true
	_notification_active = true
	if notification_timer:
		notification_timer.start(2.0)

func _on_notification_timeout() -> void:
	_notification_active = false
	if notification_label:
		notification_label.visible = false
	_update_ui_elements()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var can_collect: bool = _is_dev_mode() or (GameState and GameState.merchant_water_quest_started and not GameState.water_collected)
	var show_prompt: bool = _player_in_range and can_collect and not _notification_active
	
	if indicator:
		indicator.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
