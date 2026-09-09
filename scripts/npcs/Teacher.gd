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
var knowledge_book_ui: Node = null

func setup_managers(d_mgr: DialogueManager, q_mgr: QuizManager, dom_ui: DomainSelectionUI, math_h_ui: Node = null, astro_h_ui: Node = null, med_h_ui: Node = null, phil_h_ui: Node = null, logic_h_ui: Node = null, kb_ui: Node = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	math_heritage_ui = math_h_ui
	astro_heritage_ui = astro_h_ui
	med_heritage_ui = med_h_ui
	phil_heritage_ui = phil_h_ui
	logic_heritage_ui = logic_h_ui
	knowledge_book_ui = kb_ui
	
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

	if knowledge_book_ui:
		if not knowledge_book_ui.book_completed.is_connected(_on_knowledge_book_completed):
			knowledge_book_ui.book_completed.connect(_on_knowledge_book_completed)
		if not knowledge_book_ui.book_closed.is_connected(_on_interaction_cancelled):
			knowledge_book_ui.book_closed.connect(_on_interaction_cancelled)

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


func _is_dev_mode() -> bool:
	var dev = get_node_or_null("/root/DevModeManager")
	return dev != null and dev.dev_mode_enabled

func is_teacher_unlocked() -> bool:
	if _is_dev_mode():
		return true
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
		if GameState.teacher_admitted and not _is_dev_mode():
			current_state = State.ADMITTED
		if not GameState.merchant_state_changed.is_connected(_on_merchant_state_changed):
			GameState.merchant_state_changed.connect(_on_merchant_state_changed)
		if not GameState.quest_state_changed.is_connected(_on_merchant_state_changed):
			GameState.quest_state_changed.connect(_on_merchant_state_changed)

	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and (_is_dev_mode() or current_state == State.AVAILABLE) and is_teacher_unlocked():
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
			{"speaker": "Silabhadra", "text": "Before we test your mathematical skills, let me share the ancient knowledge granth that shaped this tradition."}
		]
		dialogue_manager.start_dialogue(math_intro_seq, func(): _open_knowledge_book(_selected_domain))
	elif d_lower == "astronomy":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var astro_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If astronomy is your path, let us see whether you understand the movements of the cosmos."},
			{"speaker": "Silabhadra", "text": "Before we test your knowledge of the stars, let me open the astronomical records of our scholars."}
		]
		dialogue_manager.start_dialogue(astro_intro_seq, func(): _open_knowledge_book(_selected_domain))
	elif d_lower == "medicine":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var med_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If medicine is your path, let us see whether you understand the art of healing and balance."},
			{"speaker": "Silabhadra", "text": "Before we test your understanding, let me open the healing treatises of our ancient physicians."}
		]
		dialogue_manager.start_dialogue(med_intro_seq, func(): _open_knowledge_book(_selected_domain))
	elif d_lower == "philosophy" or d_lower == "phil" or d_lower == "logic":
		current_state = State.HERITAGE
		_update_ui_elements()
		
		var phil_intro_seq: Array = [
			{"speaker": "Silabhadra", "text": "If philosophy is your path, let us see whether you seek wisdom through questioning and debate."},
			{"speaker": "Silabhadra", "text": "Before we test your reasoning, let me share the philosophical debates and logic of our masters."}
		]
		dialogue_manager.start_dialogue(phil_intro_seq, func(): _open_knowledge_book(_selected_domain))
	else:
		_start_domain_quiz()

func _open_knowledge_book(domain_id: String) -> void:
	if knowledge_book_ui and is_instance_valid(knowledge_book_ui) and knowledge_book_ui.has_method("open_knowledge_book"):
		knowledge_book_ui.open_knowledge_book(domain_id)
	else:
		KnowledgeBook.open_book(get_tree().root, domain_id, _on_knowledge_book_completed, _on_interaction_cancelled)

func _on_knowledge_book_completed(_domain_id: String) -> void:
	current_state = State.QUIZ
	_update_ui_elements()
	_start_domain_quiz()


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
		
		var pass_seq: Array = []
		var d_low := _selected_domain.to_lower()
		if "math" in d_low:
			pass_seq = [
				{"speaker": "Silabhadra", "text": "Well done, seeker! You have demonstrated a sharp grasp of our mathematical heritage."},
				{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates—your journey as a scholar begins!"}
			]
		elif "astro" in d_low:
			pass_seq = [
				{"speaker": "Silabhadra", "text": "Splendid! You observe the heavens and planetary rhythms with true scholarly clarity."},
				{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates—the observatory and teachers await you!"}
			]
		elif "med" in d_low:
			pass_seq = [
				{"speaker": "Silabhadra", "text": "Commendable! You understand the balance of elements and healing wisdom of Ayurveda."},
				{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates to deepen your study!"}
			]
		elif "phil" in d_low or "logic" in d_low:
			pass_seq = [
				{"speaker": "Silabhadra", "text": "Remarkable! You have shown great clarity of reasoning, discernment, and debate."},
				{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates—the great hall of discourse awaits!"}
			]
		else:
			pass_seq = [
				{"speaker": "Silabhadra", "text": "Excellent work! You have proven your dedication to knowledge and wisdom."},
				{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates—your journey begins!"}
			]
			
		if dialogue_manager:
			dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
		else:
			_on_pass_dialogue_finished()
	else:
		current_state = State.WAITING
		GameState.teacher_retry_available = false
		_update_ui_elements()
		
		var fail_msg: String = "You have much to learn. Reflect on what you have studied and try again."
		if _selected_domain.to_lower() == "mathematics" or _selected_domain.to_lower() == "math":
			fail_msg = "Not quite. Think back to the teachings of Aryabhata and Brahmagupta, and try again."
			
		var fail_seq: Array = [
			{"speaker": "Silabhadra", "text": fail_msg}
		]
		if dialogue_manager:
			dialogue_manager.start_dialogue(fail_seq, _on_fail_dialogue_finished)
		else:
			_on_fail_dialogue_finished()

func _on_interaction_cancelled() -> void:
	if current_state != State.ADMITTED and current_state != State.WAITING:
		current_state = State.AVAILABLE
		_selected_domain = ""
		_update_ui_elements()

func _on_pass_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_fail_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
		GameState.teacher_retry_available = true
	GameState.unlock_player_movement()
	_update_ui_elements()
	if cooldown_timer and not _is_dev_mode():
		cooldown_timer.start(15.0)

func _on_cooldown_timeout() -> void:
	if current_state != State.ADMITTED or _is_dev_mode():
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
	var is_available: bool = _is_dev_mode() or (current_state == State.AVAILABLE and GameState.teacher_retry_available and is_teacher_unlocked())
	var show_indicator: bool = _player_in_range and is_available
	var show_press_e: bool = _player_in_range and is_available
	
	if indicator:
		indicator.visible = show_indicator
	if press_e_label:
		press_e_label.visible = show_press_e
