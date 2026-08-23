extends StaticBody2D

enum State {
	AVAILABLE,
	INTRO_DIALOGUE,
	DOMAIN_SELECTION,
	QUIZ,
	ADMITTED,
	WAITING
}

var current_state: State = State.AVAILABLE
var _player_in_range: bool = false
var _selected_domain: String = ""

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var cooldown_timer: Timer = $CooldownTimer

# Managers (initialized or referenced from scene tree)
var dialogue_manager: DialogueManager = null
var quiz_manager: QuizManager = null
var domain_ui: DomainSelectionUI = null

func setup_managers(d_mgr: DialogueManager, q_mgr: QuizManager, dom_ui: DomainSelectionUI) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	
	if domain_ui and not domain_ui.domain_selected.is_connected(_on_domain_selected):
		domain_ui.domain_selected.connect(_on_domain_selected)
	if quiz_manager and not quiz_manager.quiz_completed.is_connected(_on_quiz_completed):
		quiz_manager.quiz_completed.connect(_on_quiz_completed)

func _ready() -> void:
	if interaction_area:

		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)

			
	if cooldown_timer and not cooldown_timer.timeout.is_connected(_on_cooldown_timeout):
		cooldown_timer.timeout.connect(_on_cooldown_timeout)
	
	if GameState and GameState.teacher_admitted:
		current_state = State.ADMITTED

	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and current_state == State.AVAILABLE:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_teacher_interaction()

func _start_teacher_interaction() -> void:
	if not dialogue_manager:
		push_error("Silabhadra: DialogueManager not assigned.")
		return
		
	current_state = State.INTRO_DIALOGUE
	_update_ui_elements()
	
	var intro_seq: Array = [
		{"speaker": "Silabhadra", "text": "Hey traveller, why are you here?"},
		{"speaker": "Player", "text": "I am here to learn."},
		{"speaker": "Silabhadra", "text": "What would you like to study?"}
	]
	
	dialogue_manager.start_dialogue(intro_seq, _on_intro_dialogue_finished)

func _on_intro_dialogue_finished() -> void:
	if not domain_ui:
		push_error("Silabhadra: DomainSelectionUI not assigned.")
		return
		
	current_state = State.DOMAIN_SELECTION
	_update_ui_elements()
	domain_ui.open_selection()

func _on_domain_selected(domain_id: String) -> void:
	if current_state != State.DOMAIN_SELECTION:
		return
		
	_selected_domain = domain_id
	GameState.selected_domain = domain_id
	
	current_state = State.QUIZ
	_update_ui_elements()
	
	var intro_text: String = QuestionData.get_domain_intro(domain_id)
	var domain_seq: Array = [
		{"speaker": "Silabhadra", "text": intro_text}
	]
	
	dialogue_manager.start_dialogue(domain_seq, _start_domain_quiz)

func _start_domain_quiz() -> void:
	if not quiz_manager:
		push_error("Silabhadra: QuizManager not assigned.")
		return
		
	quiz_manager.start_quiz(_selected_domain)

func _on_quiz_completed(score: int, _total: int, passed: bool) -> void:
	if current_state != State.QUIZ:
		return
		
	if passed:
		current_state = State.ADMITTED
		GameState.record_teacher_admission(_selected_domain, score)
		_update_ui_elements()
		
		var pass_seq: Array = [
			{"speaker": "Silabhadra", "text": "You have demonstrated that you understand the foundations. You may join us."}
		]
		dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
	else:
		current_state = State.WAITING
		GameState.teacher_retry_available = false
		_update_ui_elements()
		
		var fail_seq: Array = [
			{"speaker": "Silabhadra", "text": "You have much to learn. Try again later."}
		]
		dialogue_manager.start_dialogue(fail_seq, _on_fail_dialogue_finished)

func _on_pass_dialogue_finished() -> void:
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_fail_dialogue_finished() -> void:
	GameState.unlock_player_movement()
	_update_ui_elements()
	if cooldown_timer:
		cooldown_timer.start(15.0)

func _on_cooldown_timeout() -> void:
	if current_state != State.ADMITTED:
		current_state = State.AVAILABLE
		GameState.teacher_retry_available = true
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
	var is_available: bool = (current_state == State.AVAILABLE and GameState.teacher_retry_available)
	var show_indicator: bool = _player_in_range and is_available
	var show_press_e: bool = _player_in_range and is_available
	
	if indicator:
		indicator.visible = show_indicator
	if press_e_label:
		press_e_label.visible = show_press_e
