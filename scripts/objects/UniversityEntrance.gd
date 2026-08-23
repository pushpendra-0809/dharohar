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
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not _is_transitioning:
		if GameState and GameState.teacher_admitted:
			if event.is_action_pressed("interact"):
				get_viewport().set_input_as_handled()
				_trigger_university_transition()

func _trigger_university_transition() -> void:
	_is_transitioning = true
	_update_ui_elements()
	
	if GameState:
		GameState.mark_university_visited()
	
	var arrival_seq: Array = [
		{"speaker": "Scholar", "text": "You have arrived at Nalanda University."},
		{"speaker": "Scholar", "text": "Your journey as a scholar begins here."}
	]
	
	GameState.set_target_spawn(Vector2(65, 325), arrival_seq)
	get_tree().change_scene_to_file("res://scenes/nalanda_university.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _on_quest_state_changed() -> void:
	_update_ui_elements()

func _update_ui_elements() -> void:
	var can_enter: bool = (GameState and GameState.teacher_admitted and not _is_transitioning)
	var show_prompt: bool = _player_in_range and can_enter
	
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
