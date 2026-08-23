extends StaticBody2D

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel

func setup_manager(d_mgr: DialogueManager) -> void:
	dialogue_manager = d_mgr
	if dialogue_manager:
		if not dialogue_manager.dialogue_cancelled.is_connected(_on_interaction_cancelled):
			dialogue_manager.dialogue_cancelled.connect(_on_interaction_cancelled)

func _ready() -> void:
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)
			
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_teacher2_interaction()

func _start_teacher2_interaction() -> void:
	if not dialogue_manager:
		push_error("Teacher2: DialogueManager not assigned.")
		return
		
	if GameState and GameState.teacher2_puzzle_completed:
		var completed_seq: Array = [
			{"speaker": "Acharya", "text": "You have already uncovered what the pieces were waiting to reveal."}
		]
		dialogue_manager.start_dialogue(completed_seq, _on_dialogue_finished)
	elif GameState and GameState.teacher2_puzzle_started:
		var target: Dictionary = GameState.get_current_puzzle_target()
		var target_num: String = str(target.get("id", "1"))
		var in_progress_seq: Array = [
			{"speaker": "Acharya", "text": "Seek the scattered fragments of the Nalanda sealing. Piece " + target_num + " awaits discovery."}
		]
		dialogue_manager.start_dialogue(in_progress_seq, _on_dialogue_finished)
	else:
		var domain: String = GameState.selected_domain if GameState and GameState.selected_domain != "" else "mathematics"
		var domain_intro: String = _get_domain_puzzle_intro(domain)
		
		var start_seq: Array = [
			{"speaker": "Acharya", "text": "You have chosen your path. Knowledge is not gained by words alone."},
			{"speaker": "Acharya", "text": "Let us see what you can discover."},
			{"speaker": "Acharya", "text": domain_intro}
		]
		
		dialogue_manager.start_dialogue(start_seq, func():
			if GameState:
				GameState.start_teacher2_puzzle(domain)
			_on_dialogue_finished()
		)

func _get_domain_puzzle_intro(domain: String) -> String:
	match domain.to_lower():
		"mathematics":
			return "Numbers teach us order. Let us see whether you can find the pattern."
		"astronomy":
			return "The sky is a great teacher. Order reveals what appears hidden."
		"medicine":
			return "Knowledge of the body begins with observation. Let us see what you can piece together."
		"philosophy", "philosophy_logic", "philosophy & logic":
			return "A scholar must question, compare and reason. Let us see how carefully you think."
		_:
			return "Numbers teach us order. Let us see whether you can find the pattern."

func _on_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()

func _on_interaction_cancelled() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()

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
	var show_prompt: bool = _player_in_range
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
