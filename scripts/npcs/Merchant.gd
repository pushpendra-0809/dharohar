extends StaticBody2D

enum State {
	AVAILABLE,
	INTRO_DIALOGUE,
	QUIZ,
	PASSED,
	WAITING
}

var current_state: State = State.AVAILABLE
var _player_in_range: bool = false

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var cooldown_timer: Timer = $CooldownTimer

# Managers (initialized from scene tree)
var dialogue_manager: DialogueManager = null
var quiz_manager: QuizManager = null

func setup_managers(d_mgr: DialogueManager, q_mgr: QuizManager) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	
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
	
	if GameState and GameState.merchant_passed:
		current_state = State.PASSED

	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and current_state == State.AVAILABLE:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_merchant_interaction()

func _start_merchant_interaction() -> void:
	if not dialogue_manager:
		push_error("Merchant: DialogueManager not assigned.")
		return
		
	current_state = State.INTRO_DIALOGUE
	_update_ui_elements()
	
	var intro_seq: Array = [
		{"speaker": "Merchant", "text": "Greetings traveller! I sell wares and share knowledge of Nalanda."},
		{"speaker": "Merchant", "text": "Answer my questions about Nalanda to unlock your path ahead."}
	]
	
	dialogue_manager.start_dialogue(intro_seq, _start_merchant_quiz)

func _start_merchant_quiz() -> void:
	if not quiz_manager:
		push_error("Merchant: QuizManager not assigned.")
		return
		
	current_state = State.QUIZ
	_update_ui_elements()
	quiz_manager.start_quiz("merchant")

func _on_quiz_completed(score: int, _total: int, passed: bool) -> void:
	if current_state != State.QUIZ:
		return
		
	if passed:
		current_state = State.PASSED
		GameState.record_merchant_result(score, true)
		_update_ui_elements()
		
		var pass_seq: Array = [
			{"speaker": "Merchant", "text": "You have some knowledge of the land you seek. Nalanda lies beyond these roads. Follow the path ahead."}
		]
		dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
	else:
		current_state = State.WAITING
		GameState.merchant_retry_available = false
		GameState.record_merchant_result(score, false)
		_update_ui_elements()
		
		var fail_seq: Array = [
			{"speaker": "Merchant", "text": "Knowledge opens many doors, but you have much to learn. Help me first."},
			{"speaker": "Merchant", "text": "Collect water from the nearby pond and bring it to me."}
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
	if current_state != State.PASSED:
		current_state = State.AVAILABLE
		GameState.merchant_retry_available = true
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
	var is_available: bool = (current_state == State.AVAILABLE and GameState.merchant_retry_available)
	var show_indicator: bool = _player_in_range and is_available
	var show_press_e: bool = _player_in_range and is_available
	
	if indicator:
		indicator.visible = show_indicator
	if press_e_label:
		press_e_label.visible = show_press_e
