extends StaticBody2D

enum State {
	AVAILABLE,
	INTRO_DIALOGUE,
	DOMAIN_SELECTION,
	HERITAGE,
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
var math_heritage_ui: Node = null
var astro_heritage_ui: Node = null
var med_heritage_ui: Node = null
var phil_heritage_ui: Node = null
var logic_heritage_ui: Node = null

func setup_managers(d_mgr: DialogueManager, q_mgr: QuizManager, dom_ui: DomainSelectionUI, math_h_ui: Node = null, astro_h_ui: Node = null, med_h_ui: Node = null, phil_h_ui: Node = null, logic_h_ui: Node = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	math_heritage_ui = math_h_ui
	astro_heritage_ui = astro_h_ui
	med_heritage_ui = med_h_ui
	phil_heritage_ui = phil_h_ui
	logic_heritage_ui = logic_h_ui
	
	if domain_ui:
		if not domain_ui.domain_selected.is_connected(_on_domain_selected):
			domain_ui.domain_selected.connect(_on_domain_selected)
		if not domain_ui.selection_cancelled.is_connected(_on_interaction_cancelled):
			domain_ui.selection_cancelled.connect(_on_interaction_cancelled)
			
	if quiz_manager:
		if not quiz_manager.quiz_completed.is_connected(_on_quiz_completed):
			quiz_manager.quiz_completed.connect(_on_quiz_completed)
		if not quiz_manager.quiz_cancelled.is_connected(_on_interaction_cancelled):
			quiz_manager.quiz_cancelled.connect(_on_interaction_cancelled)
			
	if dialogue_manager:
		if not dialogue_manager.dialogue_cancelled.is_connected(_on_interaction_cancelled):
			dialogue_manager.dialogue_cancelled.connect(_on_interaction_cancelled)

	if math_heritage_ui:
		if not math_heritage_ui.heritage_completed.is_connected(_on_math_heritage_completed):
			math_heritage_ui.heritage_completed.connect(_on_math_heritage_completed)

	if astro_heritage_ui:
		if not astro_heritage_ui.heritage_completed.is_connected(_on_astro_heritage_completed):
			astro_heritage_ui.heritage_completed.connect(_on_astro_heritage_completed)

	if med_heritage_ui:
		if not med_heritage_ui.heritage_completed.is_connected(_on_med_heritage_completed):
			med_heritage_ui.heritage_completed.connect(_on_med_heritage_completed)

	if phil_heritage_ui:
		if not phil_heritage_ui.heritage_completed.is_connected(_on_phil_heritage_completed):
			phil_heritage_ui.heritage_completed.connect(_on_phil_heritage_completed)

	if logic_heritage_ui:
		if not logic_heritage_ui.heritage_completed.is_connected(_on_logic_heritage_completed):
			logic_heritage_ui.heritage_completed.connect(_on_logic_heritage_completed)

func is_teacher_unlocked() -> bool:
	if not GameState:
		return false
	return GameState.water_quest_completed or GameState.university_location_revealed or GameState.merchant_passed

func _on_merchant_state_changed() -> void:
	_update_ui_elements()

func _ready() -> void:
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)
			
	if cooldown_timer and not cooldown_timer.timeout.is_connected(_on_cooldown_timeout):
		cooldown_timer.timeout.connect(_on_cooldown_timeout)
	
	if GameState:
		if GameState.teacher_admitted:
			current_state = State.ADMITTED
		if not GameState.merchant_state_changed.is_connected(_on_merchant_state_changed):
			GameState.merchant_state_changed.connect(_on_merchant_state_changed)
		if not GameState.quest_state_changed.is_connected(_on_merchant_state_changed):
			GameState.quest_state_changed.connect(_on_merchant_state_changed)

	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and current_state == State.AVAILABLE and is_teacher_unlocked():
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
	
	var d_lower := domain_id.to_lower()
	if d_lower == "mathematics" or d_lower == "math":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var math_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "Mathematics is more than the study of numbers. In our land, scholars used mathematics to understand measurement, geometry, time, calculation, and even the movements of the heavens."},
			{"speaker": "Silabhadra", "text": "Before we test your mathematical skills, let me tell you about some of the scholars and ideas that shaped this tradition."}
		]
		dialogue_manager.start_dialogue(math_intro_seq, func():
			if math_heritage_ui:
				math_heritage_ui.open_heritage()
			else:
				_on_math_heritage_completed()
		)
	elif d_lower == "astronomy":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var astro_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If astronomy is your path, let us see whether you understand the movements of the cosmos."},
			{"speaker": "Silabhadra", "text": "Before we test your knowledge of the stars, let me share how our ancient scholars observed the heavens."}
		]
		dialogue_manager.start_dialogue(astro_intro_seq, func():
			if astro_heritage_ui:
				astro_heritage_ui.open_heritage()
			else:
				_on_astro_heritage_completed()
		)
	elif d_lower == "medicine":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var med_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If medicine is your path, let us see whether you understand the art of healing and balance."},
			{"speaker": "Silabhadra", "text": "Before we test your understanding, let me share how our ancient scholars studied health and healing."}
		]
		dialogue_manager.start_dialogue(med_intro_seq, func():
			if med_heritage_ui:
				med_heritage_ui.open_heritage()
			else:
				_on_med_heritage_completed()
		)
	elif d_lower == "philosophy":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var phil_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If philosophy is your path, let us see whether you seek wisdom through questioning and debate."},
			{"speaker": "Silabhadra", "text": "Before we test your reasoning, let me share how our ancient scholars explored the nature of truth."}
		]
		dialogue_manager.start_dialogue(phil_intro_seq, func():
			if phil_heritage_ui:
				phil_heritage_ui.open_heritage()
			else:
				_on_phil_heritage_completed()
		)
	elif d_lower == "logic":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var logic_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If logic is your path, let us see whether you can analyze arguments and deduce truth."},
			{"speaker": "Silabhadra", "text": "Before we test your logical skills, let me share how our ancient scholars developed the art of reasoning."}
		]
		dialogue_manager.start_dialogue(logic_intro_seq, func():
			if logic_heritage_ui:
				logic_heritage_ui.open_heritage()
			else:
				_on_logic_heritage_completed()
		)
	else:
		current_state = State.QUIZ
		_update_ui_elements()
		
		var intro_text: String = QuestionData.get_domain_intro(domain_id)
		var domain_seq: Array = [
			{"speaker": "Silabhadra", "text": intro_text}
		]
		
		dialogue_manager.start_dialogue(domain_seq, _start_domain_quiz)

func _on_math_heritage_completed() -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	
	var summary_seq: Array = [
		{"speaker": "Silabhadra", "text": "Now you know a little about the mathematical tradition that surrounded the age of Nalanda."},
		{"speaker": "Silabhadra", "text": "Let us see how much you have understood."}
	]
	dialogue_manager.start_dialogue(summary_seq, _start_domain_quiz)

func _on_astro_heritage_completed() -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	
	var summary_seq: Array = [
		{"speaker": "Silabhadra", "text": "The heavens were not merely something to admire. To the scholars of our tradition, they were something to observe, measure, calculate, and understand."},
		{"speaker": "Silabhadra", "text": "Now, let us see what you have learned."}
	]
	dialogue_manager.start_dialogue(summary_seq, _start_domain_quiz)

func _on_med_heritage_completed() -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	
	var summary_seq: Array = [
		{"speaker": "Silabhadra", "text": "The study of medicine required observation, patience, knowledge of nature, and the wisdom to understand what had been learned."},
		{"speaker": "Silabhadra", "text": "Now, let us see what you have remembered."}
	]
	dialogue_manager.start_dialogue(summary_seq, _start_domain_quiz)

func _on_phil_heritage_completed() -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	
	var summary_seq: Array = [
		{"speaker": "Silabhadra", "text": "A philosopher asks not just 'What is the answer?' but 'Why should I believe it?'"},
		{"speaker": "Silabhadra", "text": "Now, let us see how carefully you can reason."}
	]
	dialogue_manager.start_dialogue(summary_seq, _start_domain_quiz)

func _on_logic_heritage_completed() -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	
	var summary_seq: Array = [
		{"speaker": "Silabhadra", "text": "A clever guess may sometimes find an answer, but a scholar should explain why it must be correct."},
		{"speaker": "Silabhadra", "text": "Now, let us see whether you can reason like a scholar."}
	]
	dialogue_manager.start_dialogue(summary_seq, _start_domain_quiz)

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
		
		var pass_msg: String = "You are admitted."
		if _selected_domain.to_lower() == "mathematics" or _selected_domain.to_lower() == "math":
			pass_msg = "You have learned about the mathematical traditions of our scholars. Now, let us see how you use numbers and reasoning yourself."
			
		var pass_seq: Array = [
			{"speaker": "Silabhadra", "text": pass_msg}
		]
		dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
	else:
		current_state = State.WAITING
		GameState.teacher_retry_available = false
		_update_ui_elements()
		
		var fail_msg: String = "You have much to learn. Try again later."
		if _selected_domain.to_lower() == "mathematics" or _selected_domain.to_lower() == "math":
			fail_msg = "Not quite. Think back to what you just learned and try again."
			
		var fail_seq: Array = [
			{"speaker": "Silabhadra", "text": fail_msg}
		]
		dialogue_manager.start_dialogue(fail_seq, _on_fail_dialogue_finished)

func _on_interaction_cancelled() -> void:
	if current_state != State.ADMITTED and current_state != State.WAITING:
		current_state = State.AVAILABLE
		_selected_domain = ""
		_update_ui_elements()

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
	var is_available: bool = (current_state == State.AVAILABLE and GameState.teacher_retry_available and is_teacher_unlocked())
	var show_indicator: bool = _player_in_range and is_available
	var show_press_e: bool = _player_in_range and is_available
	
	if indicator:
		indicator.visible = show_indicator
	if press_e_label:
		press_e_label.visible = show_press_e
