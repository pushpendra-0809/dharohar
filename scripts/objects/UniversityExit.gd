extends Area2D

var _player_in_range: bool = false
var _is_transitioning: bool = false

@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not _is_transitioning:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_trigger_nalanda_return()

func _trigger_nalanda_return() -> void:
	_is_transitioning = true
	_update_ui_elements()
	
	var return_seq: Array = []
	if GameState and not GameState.has_returned_to_nalanda:
		return_seq = [
			{"speaker": "Scholar", "text": "You have returned to Nalanda."},
			{"speaker": "Scholar", "text": "Continue your journey."}
		]
		GameState.has_returned_to_nalanda = true
	
	GameState.set_target_spawn(Vector2(1055, 191), return_seq)
	get_tree().change_scene_to_file("res://scenes/nalanda.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range and not _is_transitioning
	
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
