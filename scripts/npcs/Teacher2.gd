extends StaticBody2D

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null
var math_puzzle_ui: MathematicsPuzzleUI = null

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel

func setup_manager(d_mgr: DialogueManager, m_puzzle_ui: MathematicsPuzzleUI = null) -> void:
	dialogue_manager = d_mgr
	math_puzzle_ui = m_puzzle_ui
	if dialogue_manager:
		if not dialogue_manager.dialogue_cancelled.is_connected(_on_interaction_cancelled):
			dialogue_manager.dialogue_cancelled.connect(_on_interaction_cancelled)

func _ready() -> void:
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)
			
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
		
	if GameState:
		GameState.lock_player_movement()
		
	var domain: String = GameState.selected_domain.to_lower() if GameState and GameState.selected_domain != "" else ""
	
	if GameState and GameState.math_puzzle_completed:
		var seq: Array = [
			{"speaker": "Acharya", "text": "Outstanding work! You have proven your mastery of numbers."}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
	elif domain == "mathematics" or domain == "math":
		var math_seq: Array = [
			{"speaker": "Acharya", "text": "Welcome to Nalanda University, young scholar."},
			{"speaker": "Acharya", "text": "Let us test your understanding of numbers. Solve the following problem carefully."}
		]
		dialogue_manager.start_dialogue(math_seq, func():
			if math_puzzle_ui:
				math_puzzle_ui.open_puzzle()
			else:
				_on_dialogue_finished()
		)
	else:
		var seq: Array = [
			{"speaker": "Acharya", "text": "Welcome to Nalanda University, young scholar."}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)

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

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
