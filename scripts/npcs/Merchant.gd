extends StaticBody2D

enum State {
	AVAILABLE,
	INTRO_DIALOGUE,
	QUIZ,
	PASSED,
	WATER_QUEST_ACTIVE,
	WATER_COLLECTED,
	UNIVERSITY_REVEALED
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
	
	if quiz_manager:
		if not quiz_manager.quiz_completed.is_connected(_on_quiz_completed):
			quiz_manager.quiz_completed.connect(_on_quiz_completed)
		if not quiz_manager.quiz_cancelled.is_connected(_on_interaction_cancelled):
			quiz_manager.quiz_cancelled.connect(_on_interaction_cancelled)
			
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
		if GameState.water_quest_completed or GameState.university_location_revealed:
			current_state = State.UNIVERSITY_REVEALED
		elif GameState.has_water:
			current_state = State.WATER_COLLECTED
		elif GameState.merchant_water_quest_started:
			current_state = State.WATER_QUEST_ACTIVE
		elif GameState.merchant_passed:
			current_state = State.PASSED
		
		if GameState.has_signal("player_movement_locked") and not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)

	_update_ui_elements()

func _on_movement_locked(_locked: bool) -> void:
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_merchant_interaction()

func _is_dev_mode() -> bool:
	var dev = get_node_or_null("/root/DevModeManager")
	return dev != null and dev.dev_mode_enabled

func _can_interact() -> bool:
	if dialogue_manager == null or dialogue_manager.is_active():
		return false
	if quiz_manager != null and quiz_manager.is_active():
		return false
	if GameState != null and GameState.is_movement_locked:
		return false
	if current_state == State.INTRO_DIALOGUE or current_state == State.QUIZ:
		return false
	return true

func _start_merchant_interaction() -> void:
	if not _can_interact():
		return
	if not dialogue_manager:
		push_error("Merchant: DialogueManager not assigned.")
		return

	# Dev Mode Handling: Always allow full flow testing
	if _is_dev_mode():
		if GameState and GameState.has_water:
			current_state = State.WATER_COLLECTED
			_update_ui_elements()
			var complete_seq: Array = [
				{"speaker": "Merchant", "text": "You have helped me well."},
				{"speaker": "Merchant", "text": "You have earned the knowledge you seek."},
				{"speaker": "Merchant", "text": "Nalanda lies beyond these roads. Follow the path ahead."}
			]
			dialogue_manager.start_dialogue(complete_seq, _on_water_completion_dialogue_finished)
			return
		elif GameState and (GameState.water_quest_completed or GameState.university_location_revealed or GameState.merchant_passed):
			current_state = State.UNIVERSITY_REVEALED
			_update_ui_elements()
			var repeat_seq: Array = [
				{"speaker": "Merchant", "text": "Nalanda lies beyond these roads. Follow the path ahead."}
			]
			dialogue_manager.start_dialogue(repeat_seq, _on_repeat_dialogue_finished)
			return
		elif GameState and GameState.merchant_water_quest_started:
			current_state = State.WATER_QUEST_ACTIVE
			_update_ui_elements()
			var reminder_seq: Array = [
				{"speaker": "Merchant", "text": "Bring me some water from the nearby pond."}
			]
			dialogue_manager.start_dialogue(reminder_seq, _on_reminder_dialogue_finished)
			return
		else:
			current_state = State.INTRO_DIALOGUE
			_update_ui_elements()
			var intro_seq: Array = [
				{"speaker": "Merchant", "text": "Ah, a new traveller."},
				{"speaker": "Merchant", "text": "Before you continue toward Nalanda, let us see what you have learned about this ancient place."},
				{"speaker": "Merchant", "text": "Do not worry. These are simple questions."},
				{"speaker": "Merchant", "text": "You may have already heard some of the answers on your journey here."}
			]
			dialogue_manager.start_dialogue(intro_seq, _start_merchant_quiz)
			return

	# State 1: Post Quest / Revealed persistent state
	if GameState.water_quest_completed or GameState.university_location_revealed or current_state == State.UNIVERSITY_REVEALED:
		current_state = State.UNIVERSITY_REVEALED
		_update_ui_elements()
		var repeat_seq: Array = [
			{"speaker": "Merchant", "text": "Nalanda lies beyond these roads. Follow the path ahead."}
		]
		dialogue_manager.start_dialogue(repeat_seq, _on_repeat_dialogue_finished)
		return

	# State 2: Player has collected water -> Completion dialogue
	if GameState.has_water:
		current_state = State.WATER_COLLECTED
		_update_ui_elements()
		var complete_seq: Array = [
			{"speaker": "Merchant", "text": "You have helped me well."},
			{"speaker": "Merchant", "text": "You have earned the knowledge you seek."},
			{"speaker": "Merchant", "text": "Nalanda lies beyond these roads. Follow the path ahead."}
		]
		dialogue_manager.start_dialogue(complete_seq, _on_water_completion_dialogue_finished)
		return

	# State 3: Water quest active, but player has not collected water yet -> Reminder dialogue
	if GameState.merchant_water_quest_started:
		current_state = State.WATER_QUEST_ACTIVE
		_update_ui_elements()
		var reminder_seq: Array = [
			{"speaker": "Merchant", "text": "Bring me some water from the nearby pond."}
		]
		dialogue_manager.start_dialogue(reminder_seq, _on_reminder_dialogue_finished)
		return

	# State 4: Merchant Quiz Intro (Fresh start)
	current_state = State.INTRO_DIALOGUE
	_update_ui_elements()
	var intro_seq: Array = [
		{"speaker": "Merchant", "text": "Ah, a new traveller."},
		{"speaker": "Merchant", "text": "Before you continue toward Nalanda, let us see what you have learned about this ancient place."},
		{"speaker": "Merchant", "text": "Do not worry. These are simple questions."},
		{"speaker": "Merchant", "text": "You may have already heard some of the answers on your journey here."}
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
			{"speaker": "Merchant", "text": "Well done. You understand the basics of Nalanda."},
			{"speaker": "Merchant", "text": "Nalanda lies beyond these roads. Follow the path ahead."}
		]
		dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
	else:
		current_state = State.WATER_QUEST_ACTIVE
		_update_ui_elements()
		
		var fail_seq: Array = [
			{"speaker": "Merchant", "text": "It seems you need a little more time to understand Nalanda."},
			{"speaker": "Merchant", "text": "Collect water from the nearby pond and bring it to me."}
		]
		dialogue_manager.start_dialogue(fail_seq, _on_fail_dialogue_finished)

func _on_pass_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_fail_dialogue_finished() -> void:
	GameState.start_water_quest()
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_reminder_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_water_completion_dialogue_finished() -> void:
	current_state = State.AVAILABLE if _is_dev_mode() else State.UNIVERSITY_REVEALED
	GameState.complete_water_quest()
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_repeat_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_interaction_cancelled() -> void:
	if GameState.water_quest_completed or GameState.university_location_revealed:
		current_state = State.UNIVERSITY_REVEALED
	elif GameState.has_water:
		current_state = State.WATER_COLLECTED
	elif GameState.merchant_water_quest_started:
		current_state = State.WATER_QUEST_ACTIVE
	else:
		current_state = State.AVAILABLE
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
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	var show_prompt: bool = _player_in_range and _can_interact() and not in_dialogue
	
	if indicator:
		indicator.visible = false
	if press_e_label:
		press_e_label.visible = show_prompt
