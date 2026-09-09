class_name ScholarReasoningUI
extends CanvasLayer

signal challenge_completed(passed: bool)

@onready var panel_box: Control = $PanelBox
@onready var feedback_label: Label = $PanelBox/FeedbackLabel
@onready var btn_a: Button = $PanelBox/OptionsContainer/OptionA
@onready var btn_b: Button = $PanelBox/OptionsContainer/OptionB
@onready var btn_c: Button = $PanelBox/OptionsContainer/OptionC
@onready var btn_d: Button = $PanelBox/OptionsContainer/OptionD
@onready var close_btn: Button = $PanelBox/CloseButton

var _is_active: bool = false
var _on_complete_callback: Callable

func _ready() -> void:
	add_to_group("scholar_reasoning_ui")
	visible = false
	if panel_box:
		panel_box.visible = false
	
	if btn_a and not btn_a.pressed.is_connected(_on_option_a_pressed):
		btn_a.pressed.connect(_on_option_a_pressed)
	if btn_b and not btn_b.pressed.is_connected(_on_wrong_option_pressed):
		btn_b.pressed.connect(_on_wrong_option_pressed)
	if btn_c and not btn_c.pressed.is_connected(_on_wrong_option_pressed):
		btn_c.pressed.connect(_on_wrong_option_pressed)
	if btn_d and not btn_d.pressed.is_connected(_on_wrong_option_pressed):
		btn_d.pressed.connect(_on_wrong_option_pressed)
	if close_btn and not close_btn.pressed.is_connected(hide_challenge):
		close_btn.pressed.connect(hide_challenge)

func show_challenge(callback: Callable = Callable()) -> void:
	_on_complete_callback = callback
	_is_active = true
	if GameState:
		GameState.lock_player_movement()
	if feedback_label:
		feedback_label.text = "Select the correct canonical classification for the manuscripts above:"
		feedback_label.modulate = Color(1, 0.9, 0.6, 1)
	visible = true
	if panel_box:
		panel_box.visible = true

func hide_challenge() -> void:
	_is_active = false
	visible = false
	if panel_box:
		panel_box.visible = false
	if GameState:
		GameState.unlock_player_movement()

func _on_option_a_pressed() -> void:
	if not _is_active:
		return
	if feedback_label:
		feedback_label.text = "Correct! The manuscripts are appropriately catalogued."
		feedback_label.modulate = Color(0.4, 1.0, 0.4, 1)
	if GameState:
		GameState.solve_scholar_question()
		
	challenge_completed.emit(true)
	
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(func():
		hide_challenge()
		if _on_complete_callback.is_valid():
			_on_complete_callback.call()
	)

func _on_wrong_option_pressed() -> void:
	if not _is_active:
		return
	if feedback_label:
		feedback_label.text = "Incorrect match. Think of each treatise and its core field of study."
		feedback_label.modulate = Color(1.0, 0.4, 0.4, 1)
