class_name NalandaCompletionUI
extends CanvasLayer

signal completion_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var btn_continue: Button = $MainPanel/ButtonContainer/BtnContinue
@onready var btn_hub: Button = $MainPanel/ButtonContainer/BtnHub
@onready var exp_reward_label: Label = $MainPanel/RewardBox/RewardAmount

var is_open: bool = false

func _ready() -> void:
	add_to_group("nalanda_completion_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_buttons()

func _setup_buttons() -> void:
	if btn_continue and not btn_continue.pressed.is_connected(_on_continue_pressed):
		btn_continue.pressed.connect(_on_continue_pressed)
		_setup_hover(btn_continue)
		
	if btn_hub and not btn_hub.pressed.is_connected(_on_hub_pressed):
		btn_hub.pressed.connect(_on_hub_pressed)
		_setup_hover(btn_hub)

func _setup_hover(btn: Button) -> void:
	if not btn:
		return
	if not btn.mouse_entered.is_connected(_play_hover):
		btn.mouse_entered.connect(_play_hover)

func _play_hover() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func open_completion_sequence() -> void:
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		
	if exp_reward_label:
		exp_reward_label.text = "+150 EXP (Nalanda Grand Completion)"

func close_ui() -> void:
	is_open = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
		
	completion_closed.emit()

func _on_continue_pressed() -> void:
	close_ui()

func _on_hub_pressed() -> void:
	if GameState:
		GameState.unlock_player_movement()
	get_tree().change_scene_to_file("res://scenes/experiences/experiences.tscn")
