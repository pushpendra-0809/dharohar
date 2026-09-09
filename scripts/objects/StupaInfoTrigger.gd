extends Area2D

@onready var prompt_container: Node2D = $PromptContainer
@onready var info_button: Button = $PromptContainer/InfoButton

@export var prompt_title: String = "i"

var _player_in_range: bool = false
const StupaInfoDataScript = preload("res://scripts/data/StupaInfoData.gd")

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	if info_button:
		info_button.text = "i"
		if prompt_title != "":
			info_button.text = prompt_title
		if not info_button.pressed.is_connected(_on_info_button_pressed):
			info_button.pressed.connect(_on_info_button_pressed)
		
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not _is_info_open():
		if event.is_action_pressed("interact") or (event is InputEventKey and event.is_pressed() and not event.is_echo() and (event.keycode == KEY_I or event.physical_keycode == KEY_I)):
			get_viewport().set_input_as_handled()
			_open_info_panel()

func _open_info_panel() -> void:
	var info_ui = get_tree().get_first_node_in_group("nalanda_info_ui")
	if not info_ui:
		var root = get_tree().current_scene
		if root:
			info_ui = root.get_node_or_null("NalandaInfoUI")
	if info_ui and info_ui.has_method("open_info"):
		info_ui.open_info(0, StupaInfoDataScript.CARDS)
		_update_ui_elements()

func _is_info_open() -> bool:
	var info_ui = get_tree().get_first_node_in_group("nalanda_info_ui")
	if not info_ui:
		var root = get_tree().current_scene
		if root:
			info_ui = root.get_node_or_null("NalandaInfoUI")
	if info_ui:
		return info_ui.visible
	return false

func _on_info_button_pressed() -> void:
	if _player_in_range and not _is_info_open():
		_open_info_panel()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range and not _is_info_open()
	if prompt_container:
		prompt_container.visible = show_prompt
